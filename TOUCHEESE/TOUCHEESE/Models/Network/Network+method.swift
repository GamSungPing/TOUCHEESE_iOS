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
        case .studioListRequest, .studioDetailRequest, .reviewListRequest, .reviewDetailRequest, .productDetailRequest, .reservationListRequest, .reservationDetailRequest:
            return .get
        case .studioReservationRequest:
            return .post
        case .reservationCancelRequest:
            return .delete
        }
    }
}
