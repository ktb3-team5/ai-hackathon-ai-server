"""
init.sql 파일의 여행지 데이터를 ChromaDB에 초기화하는 스크립트
"""
import re
from app.models import PlaceData
from app.service import chroma_service


def parse_sql_insert_values(sql_content: str) -> list[tuple]:
    """
    SQL INSERT 문에서 VALUES 부분을 파싱하여 데이터 추출

    Returns:
        List of tuples: (media_id, name, address, description, tags, image_url)
    """
    # INSERT INTO tb_destination로 시작하는 부분 찾기
    pattern = r'INSERT INTO tb_destination.*?VALUES\s+(.*?);'
    matches = re.findall(pattern, sql_content, re.DOTALL)

    all_destinations = []

    for match in matches:
        # 각 행의 데이터 파싱 (괄호로 묶인 값들)
        # 작은따옴표로 묶인 문자열 내부의 쉼표를 보호하기 위해 복잡한 파싱 필요
        rows = re.findall(r'\((.*?)\)(?=\s*,|\s*;|$)', match, re.DOTALL)

        for row in rows:
            # 각 필드를 파싱
            values = []
            current_value = ""
            in_quotes = False
            quote_char = None

            i = 0
            while i < len(row):
                char = row[i]

                if char in ('"', "'") and (i == 0 or row[i-1] != '\\'):
                    if not in_quotes:
                        in_quotes = True
                        quote_char = char
                    elif char == quote_char:
                        in_quotes = False
                        quote_char = None
                    current_value += char
                elif char == ',' and not in_quotes:
                    values.append(current_value.strip())
                    current_value = ""
                else:
                    current_value += char

                i += 1

            # 마지막 값 추가
            if current_value.strip():
                values.append(current_value.strip())

            # 값이 5개 또는 6개인 경우 처리 (media_id, name, address, description, tags, [image_url])
            if len(values) >= 5:
                media_id = int(values[0].strip())
                name = values[1].strip().strip('"').strip("'")
                address = values[2].strip().strip('"').strip("'")
                description = values[3].strip().strip('"').strip("'")
                tags = values[4].strip().strip('"').strip("'")

                # image_url이 있는 경우 (6번째 필드)
                image_url = None
                if len(values) >= 6:
                    img_val = values[5].strip()
                    if img_val.upper() != 'NULL':
                        image_url = img_val.strip('"').strip("'")

                all_destinations.append((media_id, name, address, description, tags, image_url))

    return all_destinations


def create_place_data_from_sql(destination_id: int, media_id: int, name: str,
                                address: str, description: str, tags_str: str, image_url: str = None) -> PlaceData:
    """
    SQL 데이터를 PlaceData 모델로 변환
    """
    # tags를 콤마로 분리하여 리스트로 변환
    tags = [tag.strip() for tag in tags_str.split(',') if tag.strip()]

    return PlaceData(
        placeId=str(destination_id),
        mediaId=media_id,
        tags=tags,
        placeName=name,
        location=address,
        description=description
    )


def init_chromadb_from_sql(sql_file_path: str = "./init_en.sql"):
    """
    init.sql 파일을 읽어서 ChromaDB에 데이터를 초기화
    """
    print("=" * 80)
    print("ChromaDB 초기화 시작")
    print("=" * 80)

    # SQL 파일 읽기
    print(f"\n1. SQL 파일 읽기: {sql_file_path}")
    with open(sql_file_path, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    # 기존 데이터 삭제
    print("\n2. 기존 ChromaDB 컬렉션 데이터 삭제 중...")
    chroma_service.delete_all()
    print("   ✓ 삭제 완료")

    # SQL에서 데이터 파싱
    print("\n3. SQL INSERT 문 파싱 중...")
    destinations = parse_sql_insert_values(sql_content)
    print(f"   ✓ 총 {len(destinations)}개의 여행지 데이터 파싱 완료")

    # PlaceData 객체로 변환
    print("\n4. PlaceData 객체 변환 중...")
    places = []
    for idx, (media_id, name, address, description, tags, image_url) in enumerate(destinations, start=1):
        place = create_place_data_from_sql(
            destination_id=idx,
            media_id=media_id,
            name=name,
            address=address,
            description=description,
            tags_str=tags,
            image_url=image_url
        )
        places.append(place)
    print(f"   ✓ {len(places)}개의 PlaceData 객체 생성 완료")

    # ChromaDB에 일괄 삽입
    print("\n5. ChromaDB에 데이터 삽입 중...")
    chroma_service.add_places_batch(places)
    print("   ✓ 데이터 삽입 완료")

    # 결과 확인
    count = chroma_service.get_collection_count()
    print(f"\n6. 검증: 현재 컬렉션에 {count}개의 데이터가 있습니다.")

    # 미디어별 통계
    print("\n" + "=" * 80)
    print("미디어별 여행지 통계")
    print("=" * 80)

    media_stats = {}
    for place in places:
        media_id = place.mediaId
        if media_id not in media_stats:
            media_stats[media_id] = []
        media_stats[media_id].append(place.placeName)

    # SQL에서 미디어 이름 매핑 (init_en.sql의 INSERT INTO tb_media 참조)
    media_names = {
        1: "Guardian: The Lonely and Great God",
        2: "K-Pop Demon Hunters",
        3: "Mr. Sunshine",
        4: "Crash Landing on You",
        5: "Hometown Cha-Cha-Cha",
        6: "Queen of Tears",
        7: "My Sweet Mobster",
        8: "Itaewon Class",
        9: "Our Beloved Summer",
        10: "Squid Game"
    }

    for media_id in sorted(media_stats.keys()):
        media_name = media_names.get(media_id, f"Unknown-{media_id}")
        place_count = len(media_stats[media_id])
        print(f"\n[Media ID: {media_id}] {media_name}")
        print(f"  - 여행지 개수: {place_count}개")
        print(f"  - 첫 번째 여행지: {media_stats[media_id][0]}")
        if place_count > 1:
            print(f"  - 마지막 여행지: {media_stats[media_id][-1]}")

    print("\n" + "=" * 80)
    print("ChromaDB 초기화 완료! ✨")
    print("=" * 80)

    return places


def test_search_by_media_id():
    """
    특정 mediaId로 필터링하여 검색 테스트
    """
    print("\n" + "=" * 80)
    print("검색 테스트: mediaId 필터링")
    print("=" * 80)

    from app.models import SearchRequest

    # 테스트 케이스 1: Guardian (mediaId=1)
    print("\n[테스트 1] Guardian (mediaId=1) - 'ocean,waves,romantic' 태그 검색")
    request = SearchRequest(
        mediaId=1,
        tags=["ocean", "waves", "romantic"]
    )
    results = chroma_service.search_places(request, n_results=5)
    print(f"  검색 결과 (상위 5개 placeId): {results}")

    # 테스트 케이스 2: Crash Landing on You (mediaId=4)
    print("\n[테스트 2] Crash Landing on You (mediaId=4) - 'ocean,beach,romantic' 태그 검색")
    request = SearchRequest(
        mediaId=4,
        tags=["ocean", "beach", "romantic"]
    )
    results = chroma_service.search_places(request, n_results=5)
    print(f"  검색 결과 (상위 5개 placeId): {results}")

    # 테스트 케이스 3: Hometown Cha-Cha-Cha (mediaId=5)
    print("\n[테스트 3] Hometown Cha-Cha-Cha (mediaId=5) - 'market,traditional,local' 태그 검색")
    request = SearchRequest(
        mediaId=5,
        tags=["market", "traditional", "local"]
    )
    results = chroma_service.search_places(request, n_results=5)
    print(f"  검색 결과 (상위 5개 placeId): {results}")

    print("\n" + "=" * 80)
    print("검색 테스트 완료!")
    print("=" * 80)


if __name__ == "__main__":
    # ChromaDB 초기화
    places = init_chromadb_from_sql()

    # 검색 테스트
    test_search_by_media_id()
