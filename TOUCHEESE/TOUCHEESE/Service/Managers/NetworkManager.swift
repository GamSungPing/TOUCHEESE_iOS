//
//  NetworkManager.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

enum NetworkError: Error {
    case unauthorized
    case decodingFailed(Error)
    case requestFailed(AFError)
    case unexpectedStatusCode(Int)
    case unknown
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init () { }
    
    private func performRequest<T: Decodable>(
        _ fetchRequest: Network,
        decodingType: T.Type
    ) async throws -> T {
        let url = fetchRequest.baseURL + fetchRequest.path
        
        let request = AF.request(
            url,
            method: fetchRequest.method,
            parameters: fetchRequest.parameters,
            encoding: fetchRequest.encoding,
            headers: fetchRequest.headers
        )
        
        let response = await request.validate()
            .serializingData()
            .response
        
        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.unknown
        }
        
        switch statusCode {
        case 200...299:
            switch response.result {
            case .success(let data):
                // print("네트워크 통신 결과 (JSON 문자열) ===== \(String(data: data, encoding: .utf8) ?? "nil")")
                let decoder = JSONDecoder()
                
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    print("\(decodingType) 디코딩 실패: \(error.localizedDescription)")
                    throw NetworkError.decodingFailed(error)
                }
            case .failure(let error):
                print("\(decodingType) 네트워크 요청 실패: \(error.localizedDescription)")
                throw NetworkError.requestFailed(error)
            }
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.unexpectedStatusCode(statusCode)
        }
    }
    
    /// Header에 Access Token을 보내야 하는 API 통신에 해당 메서드를 사용
    func performWithTokenRetry<T>(
        accessToken: String?,
        refreshToken: String?,
        operation: @escaping (String) async throws -> T
    ) async throws -> T {
        guard let accessToken, let refreshToken else {
            throw NetworkError.unauthorized
        }
        
        do {
            return try await operation(accessToken)
        } catch NetworkError.unauthorized {
            let refreshRequest = RefreshAccessTokenRequest(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
            let newTokenData = try await postRefreshAccessTokenData(
                refreshRequest
            )
            
            KeychainManager.shared.update(
                token: newTokenData.accessToken,
                forAccount: .accessToken
            )
            KeychainManager.shared.update(
                token: newTokenData.refreshToken,
                forAccount: .refreshToken
            )
            
            return try await operation(newTokenData.accessToken)
        }
    }

    
    /// 스튜디오 리스트 데이터를 요청하는 함수
    /// - Parameter concept: 스튜디오 컨셉
    /// - Parameter isHighRating: 점수 필터 (True에 적용 O, False와 Nil일 때 적용 X)
    /// - Parameter regionArray: 지역 필터 (배열에 해당하는 Region 타입을 담아서 사용)
    /// - Parameter isLowpricing: 가격 필터 (True == 낮은 가격순, False == 높은 가격순, Nil == 적용 X)
    /// - Parameter page: 페이지(페이징 처리에 사용, 서버 자체적으로 Nil일 때 기본값 1 적용)
    func getStudioListDatas(
        concept: StudioConcept,
        isHighRating: Bool? = nil,
        regionArray: [StudioRegion]? = nil,
        price: StudioPrice? = nil,
        page: Int? = nil
    ) async throws -> (list: [Studio], count: Int) {
        let fetchRequest = Network.studioListRequest(
            concept: concept,
            isHighRating: isHighRating,
            regionArray: regionArray,
            price: price,
            page: page
        )
        let studioData: StudioData = try await performRequest(
            fetchRequest,
            decodingType: StudioData.self
        )
        
        return (studioData.data.content, studioData.data.totalElementsCount)
    }
    
    /// 스튜디오의 자세한 데이터를 요청하는 함수
    /// - Parameter studioID: 스튜디오 아이디
    func getStudioDetailData(studioID id: Int) async throws -> StudioDetail {
        let fetchRequest = Network.studioDetailRequest(id: id)
        let studioDetailData: StudioDetailData = try await performRequest(
            fetchRequest,
            decodingType: StudioDetailData.self
        )
        
        return studioDetailData.data
    }
    
    
    /// 단일 스튜디오 데이터를 요청하는 함수
    /// - Parameter studioID: 스튜디오 아이디. 아이디에 해당하는 스튜디오 데이터를 불러온다.
    func getStudioData(studioID id: Int) async throws -> Studio {
        let fetchRequest = Network.studioRequest(id: id)
        let singleStudioData: SingleStudioData = try await performRequest(
            fetchRequest,
            decodingType: SingleStudioData.self
        )
        
        return singleStudioData.data
    }
    
    /// 리뷰 리스트를 요청하는 함수
    /// - Parameter studioID: 스튜디오 아이디. 아이디에 해당하는 스튜디오의 리뷰 리스트를 불러온다.
    /// - Parameter productID: 상품의 아이디. 아이디에 해당하는 상품의 리뷰 리스트를 불러온다.
    /// - Parameter page: 페이지(페이징 처리에 사용, 서버 자체적으로 nil일 때 기본값 1 적용)
    func getReviewListDatas(
        studioID: Int,
        productID: Int? = nil,
        page: Int? = nil
    ) async throws -> [Review] {
        let fetchRequest = Network.reviewListRequest(
            studioID: studioID,
            productID: productID,
            page: page
        )
        let reviewData: ReviewData = try await performRequest(fetchRequest, decodingType: ReviewData.self)
        
        return reviewData.content
    }
    
    /// 상품의 자세한 데이터를 요청하는 함수
    /// - Parameter productID: 상품의 아이디. 아이디에 해당하는 상품의 자세한 데이터를 불러온다.
    func getProductDetailData(productID id: Int) async throws -> ProductDetail {
        let fetchRequest = Network.productDetailRequest(id: id)
        let productDetailData: ProductDetailData = try await performRequest(
            fetchRequest,
            decodingType: ProductDetailData.self
        )
        return productDetailData.data
    }
    
    /// 리뷰의 자세한 데이터를 요청하는 함수
    /// - Parameter studioID: 스튜디오 아이디. 아이디에 해당하는 스튜디오를 불러온다.
    /// - Parameter reviewID: 리뷰의 아이디. 아이디에 해당하는 리뷰의 자세한 데이터를 불러온다.
    func getReviewDetailData(
        studioID: Int,
        reviewID: Int
    ) async throws -> ReviewDetail {
        let fetchRequest = Network.reviewDetailRequest(
            studioID: studioID,
            reviewID: reviewID
        )
        let reviewDetailData = try await performRequest(fetchRequest, decodingType: ReviewDetailData.self)
        
        return reviewDetailData.data
    }
    
    /// 스튜디오에 예약을 요청하는 함수
    /// - Parameter ReservationRequestType: 예약에 필요한 정보를 담은 구조체
    func postStudioReservation(
        reservationRequest: ReservationRequest,
        accessToken: String
    ) async throws -> ReservationResponseData {
        let fetchRequest = Network.studioReservationRequest(
            reservationRequest,
            accessToken: accessToken
        )
        
        let reservationResponseData = try await performRequest(
            fetchRequest,
            decodingType: ReservationResponseData.self
        )
        
        return reservationResponseData
    }
    
    /// 특정 회원의 예약 리스트를 요청하는 함수
    /// - Parameter memberID: 회원의 아이디. 아이디에 해당하는 회원의 예약 리스트를 불러온다.
    /// - Parameter isPast: true 값이면 예약 대기, 예약 확정 리스트를 불러오고, false 값이면 예약 완료, 예약 취소 리스트를 불러온다.
    func getReservationListDatas(
        accessToken: String,
        memberID: Int,
        isPast: Bool = false
    ) async throws -> [Reservation] {
        let fetchRequest = Network.reservationListRequest(
            accessToken: accessToken,
            memberID: memberID,
            isPast: isPast
        )
        let reservationData = try await performRequest(
            fetchRequest,
            decodingType: ReservationData.self
        )
        
        return reservationData.data
    }
    
    /// 특정 예약의 자세한 데이터를 요청하는 함수
    /// - Parameter reservationID: 예약 아이디. 아이디에 해당하는 예약의 자세한 데이터를 불러온다.
    func getReservationDetailData(
        reservationID id: Int
    ) async throws -> ReservationDetail {
        let fetchRequest = Network.reservationDetailRequest(id: id)
        let reservationDetailData = try await performRequest(
            fetchRequest,
            decodingType: ReservationDetailData.self
        )
        
        return reservationDetailData.data
    }
    
    /// 특정 맴버의 스튜디오 예약을 취소하는 함수
    /// - Parameter reservationID: 예약 아이디. 아이디에 해당하는 예약을 취소한다.
    /// - Parameter memberID: 회원 아이디. 아이디에 해당하는 회원의 예약 중 예약 아이디에 해당하는 예약을 취소한다.
    @discardableResult
    func deleteReservationData(
        reservationID: Int,
        memberID: Int,
        accessToken: String
    ) async throws -> ReservationCancelResponseData {
        let fetchRequest = Network.reservationCancelRequest(
            reservationID: reservationID,
            memberID: memberID,
            accessToken: accessToken
        )
        let reservationCancelResponseData = try await performRequest(fetchRequest, decodingType: ReservationCancelResponseData.self)
        
        return reservationCancelResponseData
    }
    
    /// Push Provider에게 Device Token을 등록하는 함수
    /// - Parameter deviceTokenRegistrationRequest: Device Token 등록에 필요한 정보를 담은 구조체. 구조체의 속성으로 memberId(Int)와 deviceToken(String)이 필요하다.
    @discardableResult
    func postDeviceTokenRegistrationData(
        deviceTokenRegistrationRequest: DeviceTokenRegistrationRequest,
        accessToken: String
    ) async throws -> DeviceTokenRegistrationResponse? {
        let fetchRequest = Network.deviceTokenRegistrationRequest(
            deviceTokenRegistrationRequest,
            accessToken: accessToken
        )
        let deviceTokenRegistrationResponseData = try await performRequest(
            fetchRequest,
            decodingType: DeviceTokenRegistrationResponseData.self
        )
        
        return deviceTokenRegistrationResponseData.data
    }
    
    /// 특정 날짜의 예약 가능한 시간을 조회하는 함수
    /// - Parameter studioId: 조회하려는 스튜디오의 ID 값
    /// - Parameter date: 조회하려는 날짜 값 (yyyy-MM-dd) 형식
    func getReservableTime(
        studioId: Int,
        date: Date
    ) async throws -> ReservableTimeData {
        let fetchRequest = Network.reservableTimeRequest(
            studioId: studioId,
            date: date
        )
        let reservableTimeData = try await performRequest(
            fetchRequest,
            decodingType: ReservableTimeData.self
        )
        
        return reservableTimeData
    }
    
    
    /// 서버에 소셜 로그인 정보(ID)를 보내는 함수
    /// - Parameter socialID: 각 소셜 로그인 정보의 고유 ID 값
    /// - Parameter socialType: 소셜 타입(KAKAO, APPLE)
    func postSocialId(
        socialID: String,
        socialType: SocialType
    ) async throws -> LoginResponseData {
        let fetchRequest = Network.sendSocialIDRequest(
            socialID: socialID,
            socialType: socialType
        )
        
        let loginResponseData = try await performRequest(
            fetchRequest,
            decodingType: LoginResponseData.self
        )
        
        return loginResponseData
    }
    
    /// 월요일에 코드 설명을 위해 살려둔 레거시 코드
    /// 해당 코드는 클로져 형태로 리턴받는 코드를 동기적으로 작동하게 하기 위해 코드가 지저분
    /// 개선 코드(TempKakaoLogin)는 클로져 형태의 API 관련 함수를 Async로 Wrapping 함
    func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오 로그인 진행
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("======카카오톡 로그인 성공======")
                    
                    // 사용자정보 가져오기 진행
                    UserApi.shared.me() { (user, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("======사용자정보 가져오기 성공======")
                            
                            if let socialId = user?.id {
                                // 서버에 SocialId 전송
                                Task {
                                    do {
                                        print("======사용자정보 서버에 보내기 ======")
                                        let loginResponseData = try await self.postSocialId(socialID: String(socialId), socialType: .KAKAO)
                                        
                                        // MARK: - TODO: 이후 토큰 관리 로직이 필요함
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func TempKakaoLogin() async {
        do {
            // 1. 카카오톡으로 로그인
            let oauthToken = try await loginWithKakaoTalk()
            print("카카오톡 로그인 성공: \(oauthToken)")
            
            // 2. 사용자 정보 가져오기
            let user = try await fetchKakaoUserInfo()
            print("사용자 정보 가져오기 성공: \(user)")
            
            // 3. 서버로 소셜 ID 전송
            if let socialId = user.id {
                print("사용자 정보 서버로 전송 중...")
                let loginResponseData = try await postSocialId(socialID: String(socialId), socialType: .KAKAO)
                print("서버 응답: \(loginResponseData)")
                
                // TODO: 토큰 관리 로직 추가해야 함
            }
        } catch {
            print("카카오 로그인 실패: \(error)")
        }
    }
    
    // 로그인 Wrapping
    @MainActor
    func loginWithKakaoTalk() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let oauthToken = oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
    
    // 사용자 정보 가져오기 Wrapping
    func fetchKakaoUserInfo() async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = user {
                    continuation.resume(returning: user)
                }
            }
        }
    }
    
    func postRefreshAccessTokenData(
        _ refreshAccessTokenRequest: RefreshAccessTokenRequest
    ) async throws -> RefreshAccessTokenResponse {
        let fetchRequest = Network.refreshAccessTokenRequest(
            refreshAccessTokenRequest
        )
        let refreshTokenResponseData = try await performRequest(
            fetchRequest,
            decodingType: RefreshAccessTokenResponseData.self
        )
        
        return refreshTokenResponseData.data
    }
    
    func postAppOpenData(
        _ appOpenDataRequest: AppOpenRequest
    ) async throws -> AppOpenResponse {
        let fetchRequest = Network.appOpenRequest(
            appOpenDataRequest
        )
        let appOpenResponseData = try await performRequest(
            fetchRequest,
            decodingType: AppOpenResponseData.self
        )
        
        return appOpenResponseData.data
    }
    
}
