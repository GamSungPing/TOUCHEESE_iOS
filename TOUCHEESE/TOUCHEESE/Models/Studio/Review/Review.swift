//
//  Review.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/26/24.
//

import Foundation

struct ReviewData: Codable {
    let totalPagesCount, pageNumber: Int
    let content: [Review]
}


struct Review: Identifiable, Hashable, Codable {
    let id: Int
    let imageString: String
    
    enum CodingKeys: String, CodingKey {
        case id = "reviewId"
        case imageString = "imageUrl"
    }
}


struct ReviewDetailData: Codable {
    let statusCode: Int
    let msg: String
    let data: ReviewDetail
}


struct ReviewDetail: Codable {
    let userProfileImageString: String?
    let userName: String
    let dateString: String
    
    let imageStrings: [String]
    let content: String
    let rating: Double
    
    let reply: Reply?
}


struct Reply: Identifiable, Codable {
    let id: Int
    let studioName: String
    let dateString: String
    let content: String
}


extension Review {
    static let sample = Review(
        id: 0,
        imageString: "https://i.imgur.com/Uw5nNHQ.png"
    )
    
    static let samples: [Review] = (0..<17).map { index in
        Review(
            id: index,
            imageString: "https://i.imgur.com/Uw5nNHQ.png"
        )
    }
    
    var imageURL: URL {
        URL(string: imageString) ?? .defaultImageURL
    }
}


extension ReviewDetail {
    static let sample = ReviewDetail(
        userProfileImageString: "https://i.imgur.com/Uw5nNHQ.png",
        userName: "김마루",
        dateString: "2024년 11월 28일",
        imageStrings: [
            "https://i.imgur.com/Uw5nNHQ.png",
            "https://i.imgur.com/Uw5nNHQ.png",
            "https://i.imgur.com/Uw5nNHQ.png"
        ],
        content: "인생샷을 건졌습니다, 감사합니다!!",
        rating: 4.9,
        reply: Reply.sample
    )
    
    var imageURLs: [URL] {
        imageStrings.map { imageString in
            URL(string: imageString) ?? .defaultImageURL
        }
    }
}


extension Reply {
    static let sample = Reply(
        id: 0,
        studioName: "마루 스튜디오",
        dateString: "2024년 11월 29일",
        content: "감사합니다, 고객님! 다음에 또 방문해주세요 :)"
    )
}
