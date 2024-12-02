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
            "https://imgur.com/oKoO2ca",
            "https://i.pinimg.com/736x/d2/59/7c/d2597c06b76ad83921e5c1ead54565ba.jpg",
            "https://recsofficial.cafe24.com/web/upload/NNEditor/20230112/EC9784ECA780EC9CA4_EC8580EB9FACEBB88CEBA6ACED8BB0.jpg"
        ],
        reviewCount: 2_234,
        openTime: "10:00:00",
        closeTime: "19:00:00",
        holidays: [2],
        address: "서울특별시 서초구 강남대로 11-11",
        notice: "저희 마루 스튜디오는 주차장을 따로 운영하고 있습니다! 저희 마루 스튜디오는 주차장을 따로 운영하고 있습니다! 저희 마루 스튜디오는 주차장을 따로 운영하고 있습니다!",
        products: [
            Product.sample1,
            Product.sample2,
            Product.sample3
        ],
        reviews: ReviewData(totalPagesCount: 1, pageNumber: 1, content: Review.samples)
    )
    
    var detailImageURLs: [URL] {
        detailImageStrings.map { imageString in
            URL(string: imageString) ?? URL(string: "https://i.imgur.com/Uw5nNHQ.png")!
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
            1: "일",
            2: "월",
            3: "화",
            4: "수",
            5: "목",
            6: "금",
            7: "토"
        ]
        let dayStrings = holidays.compactMap { dayMapping[$0] }
        
        return dayStrings.joined(separator: ", ")
    }
}
