//
//  TestView2.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI
import AuthenticationServices

struct TestView2: View {
    @State private var isShowingLogInView = false
    
    private let authManager = AuthenticationManager.shared
    private let keychainManager = KeychainManager.shared
    
    var body: some View {
        VStack {
            Spacer()
            
            Button {
                isShowingLogInView.toggle()
            } label: {
                Text("로그인 테스트")
            }
            
            Button {
                keychainManager.delete(forAccount: .accessToken)
                keychainManager.delete(forAccount: .refreshToken)
                
                authManager.logout()
            } label: {
                Text("로그아웃 테스트")
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isShowingLogInView) {
            LogInView(isPresented: $isShowingLogInView)
        }
    }
}

#Preview {
    TestView2()
}
