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
        VStack(spacing: 0) {
            switch navigationManager.tabItem {
            case .home:
                NavigationStack(path: $navigationManager.homePath) {
                    HomeConceptView()
                        .navigationDestination(for: ViewType.self) { viewType in
                            navigationManager.buildView(viewType: viewType)
                        }
                }
            case .reservation:
                NavigationStack(path: $navigationManager.reservationPath) {
                    ReservationListView()
                        .navigationDestination(for: ViewType.self) { viewType in
                            navigationManager.buildView(viewType: viewType)
                        }
                }
            case .likedStudios:
                TestView2()
            case .myPage:
                MyPageView()
            }
            
            if !navigationManager.isTabBarHidden {
                CustomTabBar(selectedTab: $navigationManager.tabItem)
            }
        }
    }
}


#Preview {
    ToucheeseTabView()
        .environmentObject(NavigationManager())
}
