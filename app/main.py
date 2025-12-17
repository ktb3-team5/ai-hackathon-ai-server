# ========== 기존 코드 (주석 처리) ==========
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app import __version__
from app.config import get_settings, Settings
from app.models import (
    ChatRequest,
    ChatResponse,
    HistoryResponse,
    ErrorResponse,
    HealthResponse,
)
from app.service import get_chatbot, ChatbotService

# 로깅 설정
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """앱 시작/종료 시 실행"""
    settings = get_settings()
    logger.info(f"Starting server - env: {settings.app_env}, model: {settings.gemini_model}")

    # 시작 시 챗봇 서비스 초기화
    get_chatbot()

    yield

    logger.info("Shutting down server")


def create_app() -> FastAPI:
    settings = get_settings()

    app = FastAPI(
        title="덕질 여행 챗봇 API",
        description="K-POP/드라마 팬덤 기반 여행 추천 챗봇",
        version=__version__,
        docs_url="/docs" if settings.debug else None,
        redoc_url="/redoc" if settings.debug else None,
        lifespan=lifespan,
    )

    # CORS 설정
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    return app


app = create_app()


# ========== 전역 예외 처리 ==========
@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    logger.error(f"Unhandled error: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content=ErrorResponse(
            error="Internal Server Error",
            detail=str(exc) if get_settings().debug else None
        ).model_dump()
    )


# ========== 의존성 ==========
def get_chatbot_service() -> ChatbotService:
    return get_chatbot()


# ========== 엔드포인트 ==========
@app.get(
    "/health",
    response_model=HealthResponse,
    tags=["Health"],
    summary="서버 상태 확인"
)
async def health_check(settings: Settings = Depends(get_settings)):
    """서버 및 모델 상태를 확인합니다."""
    return HealthResponse(
        status="healthy",
        version=__version__,
        environment=settings.app_env,
        model=settings.gemini_model,
    )


@app.get(
    "/stats",
    tags=["Health"],
    summary="서버 통계"
)
async def get_stats(chatbot: ChatbotService = Depends(get_chatbot_service)):
    """현재 활성 세션 수 등 서버 통계를 반환합니다."""
    return {
        "active_sessions": chatbot.get_active_sessions_count(),
    }


@app.post(
    "/chat",
    response_model=ChatResponse,
    responses={500: {"model": ErrorResponse}},
    tags=["Chat"],
    summary="챗봇과 대화"
)
async def chat(
        request: ChatRequest,
        chatbot: ChatbotService = Depends(get_chatbot_service)
):
    """
    챗봇과 대화합니다.

    - **session_id**: 사용자 세션 ID (클라이언트에서 생성)
    - **message**: 사용자 메시지
    """
    try:
        return await chatbot.chat(request)
    except Exception as e:
        logger.error(f"Chat error: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))


@app.get(
    "/chat/sessions/{session_id}/history",
    response_model=HistoryResponse,
    tags=["Chat"],
    summary="대화 히스토리 조회"
)
async def get_history(
        session_id: str,
        chatbot: ChatbotService = Depends(get_chatbot_service)
):
    """특정 세션의 대화 기록을 조회합니다."""
    history = chatbot.get_history(session_id)
    return HistoryResponse(
        session_id=session_id,
        history=history,
        message_count=len(history),
    )


@app.delete(
    "/chat/sessions/{session_id}",
    tags=["Chat"],
    summary="세션 초기화"
)
async def clear_session(
        session_id: str,
        chatbot: ChatbotService = Depends(get_chatbot_service)
):
    """특정 세션의 대화 기록을 삭제합니다."""
    if chatbot.clear_session(session_id):
        return {"success": True, "message": "세션이 초기화되었습니다."}
    raise HTTPException(status_code=404, detail="세션을 찾을 수 없습니다.")


# ========== 실행 ==========
if __name__ == "__main__":
    import uvicorn

    settings = get_settings()
    uvicorn.run(
        "app.main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.debug,
    )
