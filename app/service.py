import json
import logging
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.memory import ConversationBufferWindowMemory
from langchain_core.output_parsers import StrOutputParser

from app.config import get_settings
from app.models import ChatRequest, ChatResponse, ExtractedPreference
from app.prompts import CHAT_PROMPT, EXTRACTION_PROMPT

logger = logging.getLogger(__name__)


class ChatbotService:
    def __init__(self):
        settings = get_settings()
        self.llm = ChatGoogleGenerativeAI(
            model=settings.gemini_model,
            temperature=settings.gemini_temperature,
            google_api_key=settings.google_api_key,
            convert_system_message_to_human=True,
        )
        self.sessions: dict[str, ConversationBufferWindowMemory] = {}
        logger.info(f"ChatbotService initialized with model: {settings.gemini_model}")

    def get_memory(self, session_id: str) -> ConversationBufferWindowMemory:
        if session_id not in self.sessions:
            self.sessions[session_id] = ConversationBufferWindowMemory(
                k=10,
                memory_key="chat_history",
                return_messages=True,
            )
            logger.debug(f"New session created: {session_id}")
        return self.sessions[session_id]

    def get_history_text(self, session_id: str) -> str:
        memory = self.get_memory(session_id)
        messages = memory.chat_memory.messages
        lines = []
        for msg in messages:
            role = "사용자" if msg.type == "human" else "챗봇"
            lines.append(f"{role}: {msg.content}")
        return "\n".join(lines)

    async def chat(self, request: ChatRequest) -> ChatResponse:
        session_id = request.session_id
        user_message = request.message

        logger.info(f"Chat request - session: {session_id}, message: {user_message[:50]}...")

        # 메모리 가져오기
        memory = self.get_memory(session_id)
        chat_history = memory.chat_memory.messages

        # 현재까지 추출된 정보
        extracted_info = "아직 파악된 정보 없음"
        if chat_history:
            prefs = await self._extract_preferences(session_id)
            extracted_info = self._format_preferences(prefs)

        # 챗봇 응답 생성
        chain = CHAT_PROMPT | self.llm | StrOutputParser()
        bot_response = await chain.ainvoke({
            "user_input": user_message,
            "chat_history": chat_history,
            "extracted_info": extracted_info,
        })

        # 메모리에 저장
        memory.chat_memory.add_user_message(user_message)
        memory.chat_memory.add_ai_message(bot_response)

        # 취향 추출
        extracted_preferences = await self._extract_preferences(session_id)

        logger.info(f"Chat response - session: {session_id}, response: {bot_response[:50]}...")

        return ChatResponse(
            session_id=session_id,
            user_message=user_message,
            bot_response=bot_response,
            extracted_preferences=extracted_preferences,
        )

    async def _extract_preferences(self, session_id: str) -> ExtractedPreference:
        conversation = self.get_history_text(session_id)
        if not conversation:
            return ExtractedPreference()

        try:
            chain = EXTRACTION_PROMPT | self.llm | StrOutputParser()
            result = await chain.ainvoke({"conversation": conversation})

            # JSON 파싱 (```json``` 블록 처리)
            cleaned = result.strip()
            if cleaned.startswith("```"):
                cleaned = cleaned.split("\n", 1)[1]
                cleaned = cleaned.rsplit("```", 1)[0]

            data = json.loads(cleaned)
            return ExtractedPreference(**data)
        except (json.JSONDecodeError, ValueError) as e:
            logger.warning(f"Preference extraction failed: {e}")
            return ExtractedPreference()

    def _format_preferences(self, prefs: ExtractedPreference) -> str:
        lines = []
        if prefs.dramas:
            lines.append(f"- K-드라마: {', '.join(prefs.dramas)}")
        if prefs.movies:
            lines.append(f"- K-영화: {', '.join(prefs.movies)}")
        if prefs.actors:
            lines.append(f"- 좋아하는 배우: {', '.join(prefs.actors)}")
        if prefs.genres:
            lines.append(f"- 선호 장르: {', '.join(prefs.genres)}")
        if prefs.activities:
            lines.append(f"- 관심 활동: {', '.join(prefs.activities)}")
        if prefs.travel_style:
            lines.append(f"- 여행 스타일: {prefs.travel_style}")
        return "\n".join(lines) if lines else "아직 파악된 정보 없음"

    def get_history(self, session_id: str) -> list[dict]:
        memory = self.get_memory(session_id)
        return [
            {"role": "user" if m.type == "human" else "assistant", "content": m.content}
            for m in memory.chat_memory.messages
        ]

    def clear_session(self, session_id: str) -> bool:
        if session_id in self.sessions:
            del self.sessions[session_id]
            logger.info(f"Session cleared: {session_id}")
            return True
        return False

    def get_active_sessions_count(self) -> int:
        return len(self.sessions)


# 싱글톤 인스턴스
_chatbot_instance: ChatbotService | None = None


def get_chatbot() -> ChatbotService:
    global _chatbot_instance
    if _chatbot_instance is None:
        _chatbot_instance = ChatbotService()
    return _chatbot_instance
