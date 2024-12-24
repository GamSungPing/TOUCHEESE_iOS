//
//  LogInViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/22/24.
//

import Foundation
import AuthenticationServices

final class LogInViewModel {
    
    private let networkManager = NetworkManager.shared
    private let keychainManager = KeychainManager.shared
    private let authManager = AuthenticationManager.shared
    
    func handleAuthorizationWithApple(_ authResults: ASAuthorization) async {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            
            await postSocialID(userIdentifier, socialType: .APPLE)
        }
    }
    
    private func postSocialID(
        _ socialID: String,
        socialType: SocialType
    ) async {
        do {
            let loginResponseData = try await networkManager.postSocialId(
                socialID: socialID,
                socialType: socialType
            ).data
            
            saveTokensToKeychain(
                accessToken: loginResponseData.accessToken,
                refreshToken: loginResponseData.refreshToken
            )
            
            saveMemberInfoToAuthenticationManager(
                memberId: loginResponseData.memberId,
                memberNickname: loginResponseData.memberName
            )
            
            authManager.successfulAuthentication()
        } catch {
            print("Network Error - postSocialId: \(error.localizedDescription)")
            authManager.failedAuthentication()
        }
    }
    
    private func saveTokensToKeychain(
        accessToken: String,
        refreshToken: String
    ) {
        keychainManager.create(
            token: accessToken,
            forAccount: .accessToken
        )
        
        keychainManager.create(
            token: refreshToken,
            forAccount: .refreshToken
        )
    }
    
    private func saveMemberInfoToAuthenticationManager(
        memberId: Int,
        memberNickname: String
    ) {
        authManager.memberId = memberId
        authManager.memberNickname = memberNickname
    }
    
}
