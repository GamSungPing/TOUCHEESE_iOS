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
        case .studioDetailRequest: return [:]
            
        case .reviewListRequest(_, _, let page):
            var params: Parameters = [:]
            
            if let page { params["page"] = page }
            
            return params
        case .reviewDetailRequest: return [:]
        }
    }
}
