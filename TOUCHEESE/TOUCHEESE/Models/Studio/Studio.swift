//
//  Studio.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/18/24.
//

import Foundation

struct StudioData: Codable {
    let statusCode: Int
    let msg: String
    let data: DataClass
}


struct DataClass: Codable {
    let totalPagesCount, pageNumber: Int
    let content: [Studio]
}


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


struct StudioDetailData: Codable {
    let statusCode: Int
    let msg: String
    let data: StudioDetail
}


struct StudioDetail: Codable {
    let detailImageStrings: [String]
    let reviewCount: Int
    
    let openTime, closeTime: String
    let holidays: [Int]
    let address: String
    let notice: String?
    
    let products: [Product]
    let reviews: ReviewData
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
        URL(string: profileImageString ) ?? .defaultImageURL
    }
    
    var portfolioImageURLs: [URL] {
        portfolioImageStrings.map { string in
            URL(string: string ) ?? .defaultImageURL
        }
    }
}


extension StudioDetail {
    static let sample = StudioDetail(
        detailImageStrings: [
            "https://imgur.com/oKoO2ca.png",
            "https://imgur.com/YJaYOeA.png",
            "https://imgur.com/YJaYOeA.png"
        ],
        reviewCount: 0,
        openTime: "00:00:00",
        closeTime: "00:00:00",
        holidays: [],
        address: "주소가 표시됩니다.",
        notice: "공지사항이 표시됩니다.",
        products: [
            Product.sample1,
            Product.sample2,
            Product.sample3
        ],
        reviews: ReviewData(totalPagesCount: 1, pageNumber: 1, content: Review.samples)
    )
    
    var detailImageURLs: [URL] {
        detailImageStrings.map { imageString in
            URL(string: imageString) ?? .defaultImageURL
        }
    }
    
    var openTimeString: String {
        String(openTime.dropLast(3))
    }
    
    var closeTimeString: String {
        String(closeTime.dropLast(3))
    }
    
    var holidayString: String {
        let dayMapping: [Int: String] = [
            1: "일", 2: "월", 3: "화", 4: "수",
            5: "목", 6: "금", 7: "토"
        ]
        let dayStrings = holidays.compactMap { dayMapping[$0] }
        
        return dayStrings.joined(separator: ", ")
    }
}
