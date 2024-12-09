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
        case .studioListRequest, .studioDetailRequest, .reviewListRequest, .reviewDetailRequest, .productDetailRequest, .reservationListRequest, .reservationDetailRequest:
            return URLEncoding.default
        case .studioReservationRequest(_):
            return JSONEncoding.default
        }
    }
}
