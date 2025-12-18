from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.models import SearchRequest, SearchResponse
from app.service import chroma_service
from app.config import settings

app = FastAPI(
    title="여행지 추천 API",
    description="ChromaDB를 활용한 태그 기반 여행지 추천 시스템",
    version="1.0.0"
)

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    """API 상태 확인"""
    return {
        "status": "ok",
        "message": "여행지 추천 API가 정상 작동 중입니다.",
        "collection_count": chroma_service.get_collection_count()
    }


@app.post("/api/recommendation/content-based", response_model=SearchResponse)
async def search_places(request: SearchRequest):
    """
    태그 기반 여행지 검색

    - **mediaId**: 미디어 ID (예: 1)
    - **tags**: 검색할 태그 리스트 (예: ["바다", "감성", "일몰"])
    """
    destination_ids = chroma_service.search_places(request)
    response = SearchResponse(destinationIds=destination_ids)
    return response

@app.get("/api/test")
async def test_endpoint():
    """테스트 엔드포인트"""
    return {"message": "테스트 엔드포인트가 정상 작동 중입니다."}

@app.get("/health")
async def health_check():
    """헬스 체크"""
    return {
        "status": "healthy",
        "collection_name": chroma_service.collection.name,
        "total_places": chroma_service.get_collection_count()
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
