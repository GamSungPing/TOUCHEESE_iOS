//
//  CustomTabBar.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/22/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            Spacer()
            
            ForEach(Tab.allCases, id: \.title) { tab in
                Spacer()
                
                Button {
                    selectedTab = tab
                } label: {
                    tabButtonView(tab, isSelected: selectedTab == tab)
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(height: 70)
        
        .background {
            Rectangle()
                .fill(Color.white)
                .edgesIgnoringSafeArea(.bottom)
                .shadow(color: .black.opacity(0.06), radius: 20, y: -12)
        }
    }
    
    private func tabButtonView(_ tab: Tab, isSelected: Bool) -> some View {
        VStack(spacing: 2) {
            Image(isSelected ? tab.iconImage.selected : tab.iconImage.unselected)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(tab.title)
                .foregroundStyle(isSelected ? tab.fontColor.selected : tab.fontColor.unselected)
                .font(.pretendardMedium14)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
}
