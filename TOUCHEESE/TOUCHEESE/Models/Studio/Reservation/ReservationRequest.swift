//
//  ReservationRequest.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import Foundation

/// 예약 요청 타입
struct ReservationRequest {
    let memberId: Int
    let studioId: Int
    let reservationDate: Date
    let productName: String
    let productOptions: [ProductOption]
    let totalPrice: Int
    let phoneNumber: String
    let email: String

    var reservationDateString: String {
        reservationDate.toString(format: .requestYearMonthDay)
    }
    
    var reservationTimeString: String {
        reservationDate.toString(format: .requestTime)
    }
    
    var productOptionString: String {
        productOptions.map { "\($0.name):\($0.price)"}.joined(separator: "@")
    }
    
    var phoneNumberString: String {
        phoneNumber.phoneNumberString
    }
    
    init(
        memberId: Int,
        studioId: Int,
        reservationDate: Date,
        productName: String,
        productOptions: [ProductOption],
        totalPrice: Int,
        phoneNumber: String,
        email: String
    ) {
        self.memberId = memberId
        self.studioId = studioId
        self.reservationDate = reservationDate
        self.productName = productName
        self.productOptions = productOptions
        self.totalPrice = totalPrice
        self.phoneNumber = phoneNumber
        self.email = email
    }
}
