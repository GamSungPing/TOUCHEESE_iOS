//
//  TestView3.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct TestView3: View {
    private var networkManager = NetworkManager.shared
    
    var body: some View {
        VStack {
            Button {
                Task {
                    await networkManager.TempKakaoLogin()
                    
                }
            } label: {
                Text("로귄로귄")
            }
        }
    }
}

#Preview {
    TestView3()
}
