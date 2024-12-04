//
//  MyDiverView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/2/24.
//

import SwiftUI

struct DividerView: View {
    let horizontalPadding: CGFloat?
    let color: Color?
    let height: CGFloat?
    
    init(horizontalPadding: CGFloat? = nil, color: Color? = nil, height: CGFloat? = nil) {
        self.horizontalPadding = horizontalPadding
        self.color = color
        self.height = height
    }
    
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: height ?? 2.0)
            .foregroundStyle(color ?? .tcLightgray)
            .padding(.horizontal, horizontalPadding ?? 26)
    }
}