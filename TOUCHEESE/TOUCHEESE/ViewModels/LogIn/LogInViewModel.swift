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
    
    func handleAuthorizationWithApple(
        _ authResults: ASAuthorization,
        completion: @escaping () -> Void
    ) async {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            
            await postSocialID(userIdentifier, socialType: .APPLE)
            
            completion()
        }
    }
    
    func handleAuthorizationWithKakao() async {
        do {
            let user = try await networkManager.fetchKakaoUserInfo()
            print("사용자 정보 가져오기 성공: \(user)")
            
            if let socialId = user.id {
                print("사용자 정보 서버로 전송중...")
                await postSocialID(String(socialId), socialType: .KAKAO)
            }
        } catch {
            print("서버로 사용자 정보 전송 실패 \(error)")
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
            
            await saveMemberInfoToAuthenticationManager(
                memberId: loginResponseData.memberId,
                memberNickname: loginResponseData.memberName
            )
            
            await authManager.successfulAuthentication()
        } catch {
            print("Network Error - postSocialId: \(error.localizedDescription)")
            await authManager.failedAuthentication()
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
    
    @MainActor
    private func saveMemberInfoToAuthenticationManager(
        memberId: Int,
        memberNickname: String
    ) {
        authManager.memberId = memberId
        authManager.memberNickname = memberNickname
    }
    
    func loginWithKakaotalk() async {
        do {
            _ = try await networkManager.loginWithKakaoTalk()
        } catch {
            print("카카오 로그인 에러 \(error)")
        }
    }
}
