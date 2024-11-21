//
//  Network.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import Foundation
import Alamofire

enum Network {
    case testRequestType
    case conceptRequestType(concept: StudioConcept)
    case tempStudioRequest(
        concept: StudioConcept,
        isHighRating: Bool?,
        regionArray: [StudioRegion]?,
        price: StudioPrice?,
        page: Int?
    )
}
