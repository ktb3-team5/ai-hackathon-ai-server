from pydantic import BaseModel, Field


class PlaceData(BaseModel):
    """여행지 데이터 모델"""
    placeId: str = Field(..., description="장소 고유 ID")
    contentId: str = Field(..., description="콘텐츠 ID (드라마/영화)")
    tags: list[str] = Field(..., description="태그 리스트")
    placeName: str = Field(default="", description="장소 이름")
    location: str = Field(default="", description="위치 정보")
    description: str = Field(default="", description="장소 설명")


class SearchRequest(BaseModel):
    """검색 요청 모델"""
    contentId: str = Field(..., description="콘텐츠 ID")
    tags: list[str] = Field(..., description="검색할 태그 리스트")


class SearchResponse(BaseModel):
    """검색 응답 모델"""
    placeIds: list[str] = Field(..., description="유사도 순으로 정렬된 장소 ID 리스트")
