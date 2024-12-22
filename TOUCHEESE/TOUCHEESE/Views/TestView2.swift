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
    
    var body: some View {
        VStack {
            Spacer()
            
            Button {
                isShowingLogInView.toggle()
            } label: {
                Text("로그인 테스트")
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
