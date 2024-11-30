//
//  ContentView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct ToucheeseTabView: View {
    @State var initPageNumber: Int = 0
    
    var body: some View {
        TabView(selection: $initPageNumber) {
            NavigationStack {
                HomeConceptView()
            }
            .tint(Color.black)
            .tabItem {
                Image(systemName: "house")
                Text("홈")
            }
            .tag(0)
            
            ProductDetailView()
                .tabItem {
                    Image(systemName: "house")
                    Text("예약일정")
                }
                .tag(1)
            
            TestView2()
                .tabItem {
                    Image(systemName: "house")
                    Text("문의하기")
                }
                .tag(2)
            
            TestView3()
                .tabItem {
                    Image(systemName: "house")
                    Text("내정보")
                }
                .tag(3)
        }
    }
}

#Preview {
    ToucheeseTabView()
}
