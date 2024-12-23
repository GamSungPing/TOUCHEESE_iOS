//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getMethod() -> HTTPMethod {
        switch self {
        case .studioListRequest, .studioDetailRequest, .studioRequest, .reviewListRequest, .reviewDetailRequest, .productDetailRequest, .reservationListRequest, .reservationDetailRequest, .reservableTimeRequest:
            return .get
        case .studioReservationRequest, .deviceTokenRegistrationRequest, .sendSocialIDRequest, .refreshAccessTokenRequest:
            return .post
        case .reservationCancelRequest:
            return .delete
        }
    }
}
