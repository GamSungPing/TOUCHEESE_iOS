//
//  AuthenticationManager.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/23/24.
//

import Foundation

enum AuthStatus {
    case notAuthenticated
    case authenticated
}


final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    private(set) var authStatus: AuthStatus = .notAuthenticated
    
    var accessToken: String? {
        return KeychainManager.shared.read(forAccount: .accessToken)
    }
    var refreshToken: String? {
        return KeychainManager.shared.read(forAccount: .refreshToken)
    }
    
    var memberId: Int?
    var memberNickname: String?
    
    
    func successfulAuthentication() {
        authStatus = .authenticated
    }
    
    func failedAuthentication() {
        authStatus = .notAuthenticated
    }
    
    func logout() {
        memberId = nil
        memberNickname = nil
        
        KeychainManager.shared.delete(forAccount: .accessToken)
        KeychainManager.shared.delete(forAccount: .refreshToken)
        
        authStatus = .notAuthenticated
    }
    
    func withdrawal() {
        memberId = nil
        memberNickname = nil
        
        KeychainManager.shared.delete(forAccount: .accessToken)
        KeychainManager.shared.delete(forAccount: .refreshToken)
        
        authStatus = .notAuthenticated
    }
    
}
