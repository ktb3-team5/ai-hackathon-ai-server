# ai-server

## API 문서

- Swagger UI: http://localhost:8000/docs (개발 환경에서만)
- ReDoc: http://localhost:8000/redoc (개발 환경에서만)

## 환경 변수

| 변수 | 설명 | 기본값              |
|------|------|------------------|
| `GOOGLE_API_KEY` | Gemini API 키 | (필수)             |
| `APP_ENV` | 환경 (development/production) | development      |
| `DEBUG` | 디버그 모드 | false            |
| `PORT` | 서버 포트 | 8000             |
| `ALLOWED_ORIGINS` | CORS 허용 도메인 | *                |
| `GEMINI_MODEL` | 사용할 Gemini 모델 | gemini-2.5-flash |
