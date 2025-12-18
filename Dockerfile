FROM python:3.11-slim

WORKDIR /app

# 1단계: 시스템 패키지 설치 (거의 변경 안 됨)
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2단계: Python 패키지 설치 (requirements.txt가 변경될 때만 재실행)
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 3단계: 모델 다운로드 (한 번만 실행되고 캐시됨)
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('jhgan/ko-sroberta-multitask')"

# 4단계: 애플리케이션 코드 복사 (코드 변경 시에만 이 레이어만 재빌드)
COPY . .

RUN mkdir -p /app/chroma_db

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]