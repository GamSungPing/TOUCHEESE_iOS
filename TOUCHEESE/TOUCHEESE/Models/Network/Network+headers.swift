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
        case .studioListRequest, .studioDetailRequest, .reviewListRequest, .reviewDetailRequest, .productDetailRequest, .studioReservationRequest, .reservationListRequest:
            return ["Content-Type": "application/json"]
        }
    }
}
