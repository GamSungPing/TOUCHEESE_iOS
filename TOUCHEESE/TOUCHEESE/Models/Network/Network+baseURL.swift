//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation

extension Network {
    func getBaseURL() -> String {
        let server_url = Bundle.main.serverURL
        
        switch self {
        case .studioListRequest, .studioDetailRequest:
            return "\(server_url)/api/v1/studio"
        case .reviewListRequest, .reviewDetailRequest:
            return "\(server_url)/api/v1/review/studio"
        case .productDetailRequest:
            return "\(server_url)/api/v1/product"
        case .studioReservationRequest, .reservationDetailRequest, .reservationListRequest:
            return "\(server_url)/api/v1/reservation"
        }
    }
}
