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
    case studioRequest(id: Int)
    
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
    
    /// Product
    case productDetailRequest(id: Int)
    
    /// Reservation
    case studioReservationRequest(ReservationRequest)
    case reservationListRequest(memberID: Int, isPast: Bool)
    case reservationDetailRequest(id: Int)
    case reservationCancelRequest(reservationID: Int, memberID: Int)
    case reservableTimeRequest(studioId: Int, date: Date)
    
    /// Push Notification
    case deviceTokenRegistrationRequest(DeviceTokenRegistrationRequest)
    
    /// Login Logics
    case sendSocialIDRequest(socialID: String, socialType: SocialType)
}
