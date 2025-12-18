"""
ChromaDB에 예제 여행지 데이터를 삽입하는 스크립트
"""
from app.models import PlaceData
from app.service import chroma_service


def create_sample_data() -> list[PlaceData]:
    """예제 여행지 데이터 생성"""
    sample_places = [
        PlaceData(
            placeId="1",
            mediaId=1,
            tags=["바다", "감성", "사진명소", "일몰", "커플", "도깨비"],
            placeName="주문진항",
            location="강원도 강릉시",
            description="도깨비 촬영지로 유명한 항구"
        ),
        PlaceData(
            placeId="2",
            mediaId=1,
            tags=["산", "힐링", "트레킹", "자연", "도깨비"],
            placeName="선자령",
            location="강원도 강릉시",
            description="도깨비에 나온 아름다운 산책로"
        ),
        PlaceData(
            placeId="3",
            mediaId=1,
            tags=["카페", "감성", "인테리어", "커플", "도깨비"],
            placeName="테라로사 커피공장",
            location="강원도 강릉시",
            description="도깨비 촬영지 카페"
        ),
        PlaceData(
            placeId="4",
            mediaId=1,
            tags=["메밀밭", "자연", "사진명소", "힐링", "도깨비"],
            placeName="봉평 메밀밭",
            location="강원도 평창군",
            description="드라마 속 메밀밭 장면 촬영지"
        ),
        PlaceData(
            placeId="5",
            mediaId=1,
            tags=["해변", "바다", "산책", "일몰", "로맨틱", "도깨비"],
            placeName="경포해변",
            location="강원도 강릉시",
            description="넓은 백사장과 아름다운 일몰 명소"
        ),
        PlaceData(
            placeId="6",
            mediaId=2,
            tags=["궁궐", "역사", "전통", "사진명소", "데이트"],
            placeName="경복궁",
            location="서울특별시 종로구",
            description="조선시대 대표 궁궐"
        ),
        PlaceData(
            placeId="7",
            mediaId=2,
            tags=["한옥마을", "전통", "카페", "체험", "사진명소"],
            placeName="북촌 한옥마을",
            location="서울특별시 종로구",
            description="전통 한옥이 보존된 마을"
        ),
        PlaceData(
            placeId="8",
            mediaId=2,
            tags=["야경", "타워", "전망대", "데이트", "로맨틱"],
            placeName="남산타워",
            location="서울특별시 용산구",
            description="서울의 대표 야경 명소"
        ),
    ]
    return sample_places


def insert_sample_data():
    """예제 데이터를 ChromaDB에 삽입"""
    print("예제 데이터 생성 중...")
    sample_data = create_sample_data()

    print(f"총 {len(sample_data)}개의 여행지 데이터를 삽입합니다...")
    chroma_service.add_places_batch(sample_data)

    count = chroma_service.get_collection_count()
    print(f"삽입 완료! 현재 컬렉션에 {count}개의 데이터가 있습니다.")

    print("\n삽입된 데이터:")
    for place in sample_data:
        print(f"  - {place.placeId}: {place.placeName} ({place.location})")
        print(f"    태그: {', '.join(place.tags)}")


if __name__ == "__main__":
    insert_sample_data()
