//
//  Review.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/26/24.
//


struct Review: Identifiable {
    let id: Int
    let imageString: String
}

struct ReviewDetail {
    let userProfileImageString: String
    let userName: String
    let dateString: String
    
    let imageStrings: [String]
    let content: String
    let rating: Double
    
    let reply: Reply?
}

struct Reply: Identifiable {
    let id: Int
    let studioName: String
    let dateString: String
    let content: String
}
