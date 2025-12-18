from pydantic import BaseModel, Field


class PlaceData(BaseModel):
    """여행지 데이터 모델"""
    placeId: str = Field(..., description="장소 고유 ID")
    mediaId: int = Field(..., description="미디어 ID (드라마/영화)")
    tags: list[str] = Field(..., description="태그 리스트")
    placeName: str = Field(default="", description="장소 이름")
    location: str = Field(default="", description="위치 정보")
    description: str = Field(default="", description="장소 설명")


class SearchRequest(BaseModel):
    """검색 요청 모델"""
    mediaId: int = Field(..., alias="media_id", description="미디어 ID")
    tags: list[str] = Field(..., description="검색할 태그 리스트")

    class Config:
        populate_by_name = True  # mediaId와 media_id 둘 다 허용


class SearchResponse(BaseModel):
    """검색 응답 모델"""
    destinationIds: list[int] = Field(..., alias="destination_ids", description="유사도 순으로 정렬된 여행지 ID 리스트")

    class Config:
        populate_by_name = True  # destinationIds와 destination_ids 둘 다 허용
        by_alias = True  # 응답에서 snake_case(destination_ids) 사용
