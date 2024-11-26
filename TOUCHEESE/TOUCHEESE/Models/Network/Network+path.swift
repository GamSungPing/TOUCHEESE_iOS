//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation

extension Network {
    func getPath() -> String {
        switch self {
        case .studioRequest(
            let concept,
            let isHighRating,
            let regionArray,
            let price,
            _
        ):
            // 컨셉 경로 추가
            var path = "/concept/\(concept.rawValue)"
                       
            // 점수 경로 추가
            if let isHighRating, isHighRating {
                path += "/high-rating"
            }
            
            // 지역 경로 추가
            if let regionArray, !regionArray.isEmpty {
                path += "/regions"
            }
            
            // 가격 경로 추가
            if let price {
                switch price {
                case .all:
                    break
                case .lessThan100_000won, .lessThan200_000won, .moreThan200_000won:
                    path += "/low-pricing"
                }
            }
            
            return path
        }
    }
}
