//
//  TestView2.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI
import AuthenticationServices

struct TestView2: View {
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = []
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
                print("Apple Authorization successful.")
                handleAuthorization(authResults)
            case .failure(let error):
                print("Apple Authorization failed: \(error.localizedDescription)")
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(width: 20, height: 40)
    }
    
    func handleAuthorization(_ authResults: ASAuthorization) {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            
            print("userIdentifier: \(userIdentifier)")
        }
    }
}

#Preview {
    TestView2()
}
