//
//  ContentView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct ToucheeseTabView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        TabView(selection: $navigationManager.tabNumber) {
            NavigationStack(path: $navigationManager.homePath) {
                HomeConceptView()
                    .navigationDestination(for: ViewType.self) { viewType in
                        navigationManager.buildView(viewType: viewType)
                    }
            }
        
            .tint(Color.black)
            .tabItem {
                Image(systemName: "house")
                Text("홈")
            }
            .tag(0)
            
            NavigationStack(path: $navigationManager.reservationPath) {
                ReservationListView()
                    .navigationDestination(for: ViewType.self) { viewType in
                        navigationManager.buildView(viewType: viewType)
                    }
            }
            .tint(Color.black)
            .tabItem {
                Image(systemName: "calendar.badge.clock")
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
        .environmentObject(NavigationManager())
}
