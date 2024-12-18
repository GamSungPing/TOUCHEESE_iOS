//
//  NetworkManager.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
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
        
        switch response.result {
        case .success(let data):
            // print("네트워크 통신 결과 (JSON 문자열) ===== \(String(data: data, encoding: .utf8) ?? "nil")")
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("\(decodingType) 디코딩 실패: \(error.localizedDescription)")
                throw error
            }
        case .failure(let error):
            print("\(decodingType) 네트워크 요청 실패: \(error.localizedDescription)")
            throw error
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
    ) async throws -> [Studio] {
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
        
        return studioData.data.content
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
        let reviewData: ReviewData = try await performRequest(fetchRequest, decodingType: ReviewData.self)
      
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
        reservationRequest: ReservationRequest
    ) async throws -> ReservationResponseData {
        let fetchRequest = Network.studioReservationRequest(
            reservationRequest
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
        memberID: Int,
        isPast: Bool = false
    ) async throws -> [Reservation] {
        let fetchRequest = Network.reservationListRequest(
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
        memberID: Int
    ) async throws -> ReservationCancelResponseData {
        let fetchRequest = Network.reservationCancelRequest(
            reservationID: reservationID,
            memberID: memberID
        )
        let reservationCancelResponseData = try await performRequest(fetchRequest, decodingType: ReservationCancelResponseData.self)
        
        return reservationCancelResponseData
    }
    
    /// Push Provider에게 Device Token을 등록하는 함수
    /// - Parameter deviceTokenRegistrationRequest: Device Token 등록에 필요한 정보를 담은 구조체. 구조체의 속성으로 memberId(Int)와 deviceToken(String)이 필요하다.
    @discardableResult
    func postDeviceTokenRegistrationData(
        deviceTokenRegistrationRequest: DeviceTokenRegistrationRequest
    ) async throws -> DeviceTokenRegistrationResponse? {
        let fetchRequest = Network.deviceTokenRegistrationRequest(
            deviceTokenRegistrationRequest
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
        let fetchRequest = Network.reservableTime(
            studioId: studioId,
            date: date
        )
        let reservableTimeData = try await performRequest(
            fetchRequest,
            decodingType: ReservableTimeData.self
        )
        
        return reservableTimeData
    }
}
