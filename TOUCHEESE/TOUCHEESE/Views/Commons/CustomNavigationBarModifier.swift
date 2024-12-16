//
//  CustomNavigationBarModifier.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/12/24.
//

import SwiftUI

struct CustomNavigationBarModifier<C, L, R>: ViewModifier where C: View, L: View, R: View {
    let centerView: (() -> C)?
    let leftView: (() -> L)?
    let rightView: (() -> R)?
    let navigationBackgroundColor: Color
    
    init(
        centerView: (() -> C)? = nil,
        leftView: (() -> L)? = nil,
        rightView:(() -> R)? = nil,
        navigationBackgroundColor: Color
    ) {
        self.centerView = centerView
        self.leftView = leftView
        self.rightView = rightView
        self.navigationBackgroundColor = navigationBackgroundColor
    }
    
    func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack {
                    leftView?()
                    
                    Spacer()
                    
                    rightView?()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                HStack {
                    Spacer()
                    
                    centerView?()
                    
                    Spacer()
                }
            }
            .background(navigationBackgroundColor.ignoresSafeArea(.all, edges: .top))
            
            content
            
            // CustomNavigationBarModifier 사용 시 레이아웃이 이상해질 경우, 아래 Spacer 주석 풀어보기
            // Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}