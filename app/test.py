# # ========== Google Gemini API 연결 테스트 ==========
# import os
# from dotenv import load_dotenv
# from langchain_google_genai import ChatGoogleGenerativeAI
#
# def test_gemini_api():
#     """Google Gemini API 연결 및 기본 동작 테스트"""
#
#     print("=" * 60)
#     print("Google Gemini API 연결 테스트")
#     print("=" * 60)
#
#     # 1. .env 파일 로드
#     load_dotenv()
#     api_key = os.getenv("GOOGLE_API_KEY")
#
#     if not api_key:
#         print("❌ GOOGLE_API_KEY를 찾을 수 없습니다.")
#         print("   .env 파일에 GOOGLE_API_KEY가 설정되어 있는지 확인하세요.")
#         return
#
#     print(f"✅ API 키 로드 성공 (길이: {len(api_key)}자)")
#     print(f"   키 시작 부분: {api_key[:15]}...")
#     print()
#
#     # 2. 모델 초기화
#     try:
#         model_name = os.getenv("GEMINI_MODEL", "gemini-1.5-flash")
#         print(f"📦 모델 초기화 중: {model_name}")
#
#         llm = ChatGoogleGenerativeAI(
#             model=model_name,
#             temperature=0.7,
#             google_api_key=api_key
#         )
#         print(f"✅ 모델 초기화 성공")
#         print()
#     except Exception as e:
#         print(f"❌ 모델 초기화 실패: {e}")
#         return
#
#     # 3. 간단한 프롬프트 테스트
#     try:
#         print("💬 API 호출 테스트 중...")
#         test_prompt = "안녕하세요! 당신은 누구인가요? 간단히 한 문장으로 답변해주세요."
#
#         response = llm.invoke(test_prompt)
#
#         print("✅ API 호출 성공!")
#         print()
#         print("-" * 60)
#         print(f"질문: {test_prompt}")
#         print(f"답변: {response.content}")
#         print("-" * 60)
#         print()
#
#     except Exception as e:
#         print(f"❌ API 호출 실패: {e}")
#         return
#
#     # 4. 추가 테스트: 한국어 대화
#     try:
#         print("💬 한국어 대화 테스트 중...")
#         test_prompt2 = "서울에서 가장 유명한 관광지 3곳만 추천해주세요."
#
#         response2 = llm.invoke(test_prompt2)
#
#         print("✅ 한국어 대화 성공!")
#         print()
#         print("-" * 60)
#         print(f"질문: {test_prompt2}")
#         print(f"답변: {response2.content}")
#         print("-" * 60)
#         print()
#
#     except Exception as e:
#         print(f"❌ 한국어 대화 실패: {e}")
#         return
#
#     print("=" * 60)
#     print("🎉 모든 테스트 완료! Google Gemini API가 정상 작동합니다.")
#     print("=" * 60)
#
#
# if __name__ == "__main__":
#     test_gemini_api()
