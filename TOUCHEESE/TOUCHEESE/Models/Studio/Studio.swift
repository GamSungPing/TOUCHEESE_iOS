//
//  Studio.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/18/24.
//

import Foundation

// MARK: - Welcome
struct StudioData: Codable {
    let statusCode: Int
    let msg: String
    let data: DataClass
}


// MARK: - DataClass
struct DataClass: Codable {
    let totalElementsCount, pageElementsCount, totalPagesCount, pageNumber: Int
    let content: [Studio]
}


// MARK: - Content
struct Studio: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let profilePrice: Int
    let rating: Double
    let profileImageString: String
    let portfolioImageStrings: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePrice
        case rating
        case profileImageString = "profileURL"
        case portfolioImageStrings = "portfolioUrls"
    }
}


struct StudioDetail {
    let detailImageStrings: [String]
    
    let reviewCount: Int
    let businessHours: String
    let address: String
    
    let notice: String?
    let products: [Product]
    var reviews: [Review]?
}


extension Studio {
    static let sample = Studio(
        id: 1,
        name: "마루 스튜디오",
        profilePrice: 99_000,
        rating: 3.2,
        profileImageString: "https://i.imgur.com/Uw5nNHQ.png",
        portfolioImageStrings: ["https://i.imgur.com/Uw5nNHQ.png", "https://i.imgur.com/Uw5nNHQ.png"]
    )
    
    var formattedRating: String {
        return String(format: "%.1f", rating)
    }
    
    var profileImageURL: URL {
        URL(string: profileImageString ) ?? URL(string: "https://i.imgur.com/Uw5nNHQ.png")!
    }
    
    var portfolioImageURLs: [URL] {
        portfolioImageStrings.map { string in
            URL(string: string ) ?? URL(string: "https://i.imgur.com/Uw5nNHQ.png")!
        }
    }
}


extension StudioDetail {
    static let sample = StudioDetail(
        detailImageStrings: [
            "https://i.imgur.com/Uw5nNHQ.png",
            "https://i.imgur.com/Uw5nNHQ.png",
            "https://i.imgur.com/Uw5nNHQ.png"
        ],
        reviewCount: 2_234,
        businessHours: "월~금 10:10~19:00 / 매주 월요일 휴무",
        address: "서울특별시 서초구 강남대로 11-11",
        notice: "저희 마루 스튜디오는 주차장을 따로 운영하고 있습니다! 저희 마루 스튜디오는 주차장을 따로 운영하고 있습니다! 저희 마루 스튜디오는 주차장을 따로 운영하고 있습니다!",
        products: [
            Product.sample1,
            Product.sample1,
            Product.sample1
        ],
        reviews: [
            Review.sample,
            Review.sample,
            Review.sample,
            Review.sample,
            Review.sample
        ]
    )
    
    var detailImageURLs: [URL] {
        detailImageStrings.map { imageString in
            URL(string: imageString) ?? URL(string: "https://i.imgur.com/Uw5nNHQ.png")!
        }
    }
}
