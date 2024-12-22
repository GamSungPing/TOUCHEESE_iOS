//
//  LogInViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/22/24.
//

import Foundation
import AuthenticationServices

final class LogInViewModel {
    
    func handleAuthorization(_ authResults: ASAuthorization) {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            
            print("userIdentifier: \(userIdentifier)")
        }
    }
    
}
