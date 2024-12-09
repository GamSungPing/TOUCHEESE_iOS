//
//  ReservationDetail.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

struct ReservationDetailData: Codable {
    let statusCode: Int
    let msg: String
    let data: ReservationDetail
}


struct ReservationDetail: Codable {
    let id: Int
    let studioId: Int
    let memberName, memberEmail, phoneNumber: String
    let productOption: String
    let totalPrice: Int
    let studioAddress: String
}


extension ReservationDetail {
    static let sample = ReservationDetail(
        id: 0,
        studioId: 1,
        memberName: "김마루",
        memberEmail: "sjybext@naver.com",
        phoneNumber: "01011112222",
        productOption: "고화질 원본 전체:2000@보정본 추가:10000",
        totalPrice: 230_000,
        studioAddress: "서울 강남구 강남대로120길 76 2층"
    )
    
    var parsedProductOptions: [ProductOption] {
        productOption
            .split(separator: "@")
            .enumerated()
            .compactMap { index, optionString in
                let components = optionString.split(separator: ":").map(String.init)
                
                guard components.count == 2, let price = Int(components[1]) else {
                    assertionFailure("Invalid product option format: \(optionString)")
                    
                    return nil
                }
                
                return ProductOption(id: index, name: components[0], price: price)
            }
    }
}

