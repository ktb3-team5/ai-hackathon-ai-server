import json
import chromadb
from chromadb.utils import embedding_functions
from app.config import settings
from app.models import PlaceData, SearchRequest


class ChromaDBService:
    """ChromaDB 벡터 데이터베이스 서비스"""

    def __init__(self):
        self.client = chromadb.PersistentClient(path=settings.CHROMA_DB_PATH)
        self.embedding_function = embedding_functions.SentenceTransformerEmbeddingFunction(
            model_name=settings.EMBEDDING_MODEL
        )
        self.collection = self.client.get_or_create_collection(
            name=settings.CHROMA_COLLECTION_NAME,
            embedding_function=self.embedding_function,
            metadata={"description": "여행지 추천을 위한 콘텐츠 기반 벡터 DB"}
        )

    def add_place(self, place: PlaceData) -> None:
        """단일 여행지 데이터 추가"""
        document = " ".join(place.tags)

        self.collection.add(
            ids=[place.placeId],
            documents=[document],
            metadatas=[{
                "placeId": place.placeId,
                "contentId": place.contentId,
                "tags": json.dumps(place.tags, ensure_ascii=False),
                "placeName": place.placeName,
                "location": place.location,
                "description": place.description
            }]
        )

    def add_places_batch(self, places: list[PlaceData]) -> None:
        """여러 여행지 데이터 일괄 추가"""
        ids = [place.placeId for place in places]
        documents = [" ".join(place.tags) for place in places]
        metadatas = [
            {
                "placeId": place.placeId,
                "contentId": place.contentId,
                "tags": json.dumps(place.tags, ensure_ascii=False),
                "placeName": place.placeName,
                "location": place.location,
                "description": place.description
            }
            for place in places
        ]

        self.collection.add(
            ids=ids,
            documents=documents,
            metadatas=metadatas
        )

    def search_places(self, search_request: SearchRequest, n_results: int = 100) -> list[str]:
        """태그 기반 유사도 검색"""
        query_text = " ".join(search_request.tags)

        results = self.collection.query(
            query_texts=[query_text],
            where={"contentId": search_request.contentId},
            n_results=n_results
        )

        if not results["metadatas"] or not results["metadatas"][0]:
            return []

        place_ids = [metadata["placeId"] for metadata in results["metadatas"][0]]
        return place_ids

    def get_collection_count(self) -> int:
        """컬렉션의 총 데이터 개수 조회"""
        return self.collection.count()

    def delete_all(self) -> None:
        """컬렉션의 모든 데이터 삭제"""
        self.client.delete_collection(name=settings.CHROMA_COLLECTION_NAME)
        self.collection = self.client.get_or_create_collection(
            name=settings.CHROMA_COLLECTION_NAME,
            embedding_function=self.embedding_function,
            metadata={"description": "여행지 추천을 위한 콘텐츠 기반 벡터 DB"}
        )


# 싱글톤 인스턴스
chroma_service = ChromaDBService()
