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
                .onChange(of: navigationManager.homePath) { newPath in
                    navigationManager.isTabBarHidden = newPath.count >= 2
                }
            case .reservation:
                NavigationStack(path: $navigationManager.reservationPath) {
                    ReservationListView()
                        .navigationDestination(for: ViewType.self) { viewType in
                            navigationManager.buildView(viewType: viewType)
                        }
                }
                .onChange(of: navigationManager.homePath) { newPath in
                    navigationManager.isTabBarHidden = newPath.count >= 1
                }
            case .likedStudios:
                TestView2()
            case .myPage:
                TestView3()
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
