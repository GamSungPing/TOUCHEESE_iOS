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
    
    init(
        centerView: (() -> C)? = nil,
        leftView: (() -> L)? = nil,
        rightView:(() -> R)? = nil
    ) {
        self.centerView = centerView
        self.leftView = leftView
        self.rightView = rightView
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
            .background(Color.tcGray01.ignoresSafeArea(.all, edges: .top))
            
            content
            
            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
