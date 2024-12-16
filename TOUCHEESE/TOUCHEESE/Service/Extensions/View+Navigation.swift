//
//  View+Navigation.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/12/24.
//

import SwiftUI

extension View {
    func customNavigationBar<C>(
        backgroundColor: Color? = .tcGray01,
        centerView: @escaping (() -> C)
    ) -> some View where C: View {
        modifier (
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: {
                    EmptyView()
                },
                rightView: {
                    EmptyView()
                },
                navigationBackgroundColor: backgroundColor ?? .tcGray01)
        )
    }
    
    func customNavigationBar<C, L>(
        backgroundColor: Color? = .tcGray01,
        centerView: @escaping (() -> C),
        leftView: @escaping (() -> L)
    ) -> some View where C: View, L: View {
        modifier (
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: leftView,
                rightView: {
                    EmptyView()
                },
                navigationBackgroundColor: backgroundColor ?? .tcGray01)
        )
    }
    
    func customNavigationBar<C, L, R>(
        backgroundColor: Color? = .tcGray01,
        centerView: @escaping (() -> C),
        leftView: @escaping (() -> L),
        rightView: @escaping (() -> R)
    ) -> some View where C: View, L: View, R: View {
        modifier (
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: leftView,
                rightView: rightView,
                navigationBackgroundColor: backgroundColor ?? .tcGray01
            )
        )
    }
}
