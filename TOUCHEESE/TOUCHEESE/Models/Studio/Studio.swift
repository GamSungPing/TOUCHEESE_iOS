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
struct Studio: Codable, Identifiable {
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
