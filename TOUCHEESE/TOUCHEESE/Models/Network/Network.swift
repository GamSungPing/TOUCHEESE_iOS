//
//  Network.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import Foundation
import Alamofire

enum Network {
    /// Studio
    case studioListRequest(
        concept: StudioConcept,
        isHighRating: Bool?,
        regionArray: [StudioRegion]?,
        price: StudioPrice?,
        page: Int?
    )
    case studioDetailRequest(id: Int)
    
    /// Review
    case reviewListRequest(
        studioID: Int,
        productID: Int?,
        page: Int?
    )
    case reviewDetailRequest(
        studioID: Int,
        reviewID: Int
    )
}
