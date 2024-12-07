//
//  ReservationResponse.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import Foundation

struct ReservationResponse: Codable {
    let statusCode: Int
    let msg: String
    let data: ReservationData
}

struct ReservationData: Codable {
    let id: Int
    let studioName: String
    let memberName: String
    let memberEmail: String
    let phoneNumber: String
    let reservationDate: String
    let reservationTime: String
    let productOption: String
    let totalPrice: Int
    let studioAddress: String
}
