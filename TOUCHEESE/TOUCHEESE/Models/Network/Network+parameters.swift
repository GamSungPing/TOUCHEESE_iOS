//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getParameters() -> Parameters? {
        switch self {
        case .studioListRequest(
            _,
            _,
            let regionArray,
            let price,
            let page
        ):
            var params: Parameters = [:]
            
            if let regionArray {
                params["regionIds"] = regionArray.map { $0.rawValue }
            }
            
            if let price {
                switch price {
                case .all:
                    break
                case .lessThan100_000won:
                    params["priceCategory"] = "LOW"
                case .lessThan200_000won:
                    params["priceCategory"] = "MEDIUM"
                case .moreThan200_000won:
                    params["priceCategory"] = "HIGH"
                }
            }
            
            if let page = page {
                params["page"] = page
            }
            
            return params
        case .reviewListRequest(_, _, let page):
            var params: Parameters = [:]
            
            if let page { params["page"] = page }
            
            return params
        case .studioDetailRequest, .studioRequest, .reviewDetailRequest, .productDetailRequest, .reservationListRequest, .reservationDetailRequest:
            return [:]
        case .studioReservationRequest(let reservationRequestType):
            var params: Parameters = [:]
            
            params["memberId"] = reservationRequestType.memberId
            params["studioId"] = reservationRequestType.studioId
            params["reservationDate"] = reservationRequestType.reservationDateString
            params["reservationTime"] = reservationRequestType.reservationTimeString
            params["productId"] = reservationRequestType.productId
            params["productOption"] = reservationRequestType.productOptionString
            params["totalPrice"] = reservationRequestType.totalPrice
            params["phoneNumber"] = reservationRequestType.phoneNumberString
            params["email"] = reservationRequestType.email
            params["addPeopleCnt"] = reservationRequestType.addPeopleCnt
            
            return params
        case .reservationCancelRequest(_, let memberID):
            return ["memberId": memberID]
        case .deviceTokenRegistrationRequest(let deviceTokenRegistrationRequest):
            var params: Parameters = [:]
            
            params["memberId"] = deviceTokenRegistrationRequest.memberId
            params["deviceToken"] = deviceTokenRegistrationRequest.deviceToken
            
            return params
        case .reservableTime(studioId: let studioId, date: let date):
            var params: Parameters = [:]
            
            params["date"] = date.toString(format: .requestYearMonthDay)
            
            return params
        }
    }
}
