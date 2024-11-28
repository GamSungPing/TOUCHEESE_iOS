//
//  Product.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/26/24.
//

import Foundation

struct Product: Identifiable {
    let id: Int
    let name: String
    let description: String
    let imageString: String
    let price: Int
    let reviewCount: Int
}


struct ProductDetail {
    let isGroup: Bool
    let baseGuestCount: Int?
    let addPeoplePrice: Int?
    
    let productOptions: [ProductOption]
}


struct ProductOption: Identifiable {
    let id: Int
    let name: String
    let price: Int
}


extension Product {
    static let sample1 = Product(
        id: 1,
        name: "증명사진",
        description: "신원 확인이 주된 목적이 사진 입니다. 주로 공식 문서 및 신분증에 사용되는 사진으로 여권, 운전면허증, 학생증 등과 함께 나타납니다.",
        imageString: "https://i.imgur.com/Uw5nNHQ.png",
        price: 75000,
        reviewCount: 108
    )
}


extension ProductDetail {
    static let sample1 = ProductDetail(
        isGroup: true,
        baseGuestCount: 4,
        addPeoplePrice: 25000,
        productOptions: [ProductOption.sample1, ProductOption.sample2, ProductOption.sample3]
    )
}


extension ProductOption {
    static let sample1 = ProductOption(
        id: 1,
        name: "보정 사진 추가",
        price: 30000
    )
    
    static let sample2 = ProductOption(
        id: 2,
        name: "원본 전체 받기",
        price: 10000
    )
    
    static let sample3 = ProductOption(
        id: 3,
        name: "액자 프린팅",
        price: 15000
    )
}
