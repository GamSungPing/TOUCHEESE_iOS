//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getEncoding() -> ParameterEncoding {
        switch self {
        case .studioListRequest, .studioDetailRequest, .studioRequest, .reviewListRequest, .reviewDetailRequest, .productDetailRequest, .reservationListRequest, .reservationDetailRequest, .reservationCancelRequest, .reservableTimeRequest, .studioLikeCancelRequest, .studioLikeListRequest:
            return URLEncoding.default
        case .studioReservationRequest, .deviceTokenRegistrationRequest, .sendSocialIDRequest, .refreshAccessTokenRequest, .appOpenRequest, .logoutRequest, .withdrawalRequest, .nicknameChangeRequest, .studioLikeRequest:
            return JSONEncoding.default
        }
    }
}
