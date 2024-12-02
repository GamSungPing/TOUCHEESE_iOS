//
//  Product.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/26/24.
//

import Foundation

struct Product: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let description: String
    let imageString: String
    let price: Int
    let reviewCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, imageString, price
        case reviewCount = "reviewCnt"
    }
}


struct ProductDetailData: Codable {
    let statusCode: Int
    let msg: String
    let data: ProductDetail
}


struct ProductDetail: Codable {
    let isGroup: Bool
    let baseGuestCount: Int?
    let addPeoplePrice: Int?
    
    let productOptions: [String]
}


struct ProductOption: Identifiable, Codable {
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
        price: 7_5000,
        reviewCount: 108
    )
    
    static let sample2 = Product(
        id: 2,
        name: "배우st 프로필",
        description: "신원 확인이 주된 목적이 사진 입니다. 주로 공식 문서 및 신분증에 사용되는 사진으로 여권, 운전면허증, 학생증 등과 함께 나타납니다.",
        imageString: "https://i.imgur.com/Uw5nNHQ.png",
        price: 250_000,
        reviewCount: 143
    )
    
    static let sample3 = Product(
        id: 3,
        name: "패키지 촬영",
        description: "신원 확인이 주된 목적이 사진 입니다. 주로 공식 문서 및 신분증에 사용되는 사진으로 여권, 운전면허증, 학생증 등과 함께 나타납니다.",
        imageString: "https://i.imgur.com/Uw5nNHQ.png",
        price: 150_000,
        reviewCount: 143
    )
    
    var imageURL: URL {
        URL(string: imageString) ?? .defaultImageURL
    }
}


extension ProductDetail {
    static let sample1 = ProductDetail(
        isGroup: true,
        baseGuestCount: 4,
        addPeoplePrice: 25000,
        productOptions: ["1:셀프촬영추가:50000", "2:필터:7000", "3:혈색:3000"]
    )
    
    var parsedProductOptions: [ProductOption] {
        return productOptions.compactMap { optionString in
            let components = optionString.split(separator: ":").map { String($0) }
            
            guard components.count == 3,
                  let id = Int(components[0]),
                  let price = Int(components[2])
            else {
                print("Invalid format: \(optionString)")
                return nil
            }
            
            let name = components[1]
            
            return ProductOption(id: id, name: name, price: price)
        }
    }
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
