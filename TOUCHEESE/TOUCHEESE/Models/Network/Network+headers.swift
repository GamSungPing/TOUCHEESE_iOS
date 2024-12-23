//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getHeaders() -> HTTPHeaders? {
        switch self {
        case .studioListRequest, .studioDetailRequest, .studioRequest, .reviewListRequest, .reviewDetailRequest, .productDetailRequest, .studioReservationRequest, .reservationDetailRequest, .reservationCancelRequest, .deviceTokenRegistrationRequest, .reservableTimeRequest, .refreshAccessTokenRequest:
            return ["Content-Type": "application/json"]
        case .sendSocialIDRequest(socialID: let socialID, _:_):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["socialId"] = socialID
            
            return headers
        case .reservationListRequest(let accessToken, _, _):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(accessToken)"
            
            return headers
        }
    }
}
