//
//  StudioFilter.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/15/24.
//

import Foundation

enum StudioFilter {
    case area
    case price
    case rating
    
    var title: String {
        switch self {
        case .area: "지역별"
        case .price: "가격순"
        case .rating: "평점 높은순"
        }
    }
    
    var options: [any OptionType] {
        switch self {
        case .area: StudioRegion.allCases
        case .price: StudioPrice.allCases
        case .rating: []
        }
    }
}
