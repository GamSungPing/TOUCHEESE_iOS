//
//  ContentView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct ToucheeseTabView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tempNavigationManager: TempNavigationManager
    
    var body: some View {
        TabView(selection: $tempNavigationManager.tabNumber) {
            NavigationStack(path: $tempNavigationManager.homePath) {
                HomeConceptView()
                    .navigationDestination(for: ViewType.self) { viewType in
                        tempNavigationManager.buildView(viewType: viewType)
                    }
            }
            .tint(Color.black)
            .tabItem {
                Image(systemName: "house")
                Text("홈")
            }
            .tag(0)
            
            NavigationStack(path: $tempNavigationManager.reservationPath) {
                ReservationListView()
                    .navigationDestination(for: ViewType.self) { viewType in
                        tempNavigationManager.buildView(viewType: viewType)
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
