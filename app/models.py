from pydantic import BaseModel, Field
from datetime import datetime


class ChatRequest(BaseModel):
    session_id: str = Field(..., min_length=1, max_length=100, description="세션 ID")
    message: str = Field(..., min_length=1, max_length=2000, description="사용자 메시지")

    model_config = {
        "json_schema_extra": {
            "example": {
                "session_id": "user_12345",
                "message": "안녕하세요! 저는 도깨비 좋아해요"
            }
        }
    }


class ExtractedPreference(BaseModel):
    dramas: list[str] = Field(default_factory=list, description="좋아하는 K-드라마")
    movies: list[str] = Field(default_factory=list, description="좋아하는 K-영화")
    actors: list[str] = Field(default_factory=list, description="좋아하는 배우")
    genres: list[str] = Field(default_factory=list, description="선호 장르")
    activities: list[str] = Field(default_factory=list, description="관심 활동")
    travel_style: str | None = Field(default=None, description="여행 스타일")
    confidence: float = Field(default=0.0, ge=0.0, le=1.0, description="신뢰도")


class ChatResponse(BaseModel):
    success: bool = True
    session_id: str
    user_message: str
    bot_response: str
    extracted_preferences: ExtractedPreference
    timestamp: datetime = Field(default_factory=datetime.now)


class HistoryResponse(BaseModel):
    success: bool = True
    session_id: str
    history: list[dict]
    message_count: int


class ErrorResponse(BaseModel):
    success: bool = False
    error: str
    detail: str | None = None


class HealthResponse(BaseModel):
    status: str
    version: str
    environment: str
    model: str
