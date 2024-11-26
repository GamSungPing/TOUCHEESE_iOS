//
//  Product.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/26/24.
//


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
