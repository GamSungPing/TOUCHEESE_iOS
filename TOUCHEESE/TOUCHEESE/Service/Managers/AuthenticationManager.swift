//
//  AuthenticationManager.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/23/24.
//

import Foundation

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private(set) var authStatus: AuthStatus = .notAuthenticated
    
    var accessToken: String? {
        return KeychainManager.shared.read(forAccount: .accessToken)
    }
    var refreshToken: String? {
        return KeychainManager.shared.read(forAccount: .refreshToken)
    }
    
    var memberId: Int?
    var memberNickname: String?
    
    private init() {}
    
    func successfulAuthentication() {
        authStatus = .authenticated
    }
    
    func failedAuthentication() {
        authStatus = .notAuthenticated
    }
    
    func logout() {
        authStatus = .notAuthenticated
    }
    
}

enum AuthStatus {
    case notAuthenticated
    case authenticated
}
