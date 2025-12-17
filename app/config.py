from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    # 앱 설정
    app_env: str = "development"
    debug: bool = False
    host: str = "0.0.0.0"
    port: int = 8000

    # Google Gemini
    google_api_key: str
    gemini_model: str = "gemini-1.5-flash"
    gemini_temperature: float = 0.7

    # Redis (선택)
    redis_url: str | None = None

    # CORS
    allowed_origins: str = "*"

    @property
    def cors_origins(self) -> list[str]:
        if self.allowed_origins == "*":
            return ["*"]
        return [origin.strip() for origin in self.allowed_origins.split(",")]

    @property
    def is_production(self) -> bool:
        return self.app_env == "production"

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


@lru_cache
def get_settings() -> Settings:
    return Settings()
