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
