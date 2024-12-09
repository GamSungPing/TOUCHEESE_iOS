//
//  TOUCHEESEApp.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct TOUCHEESEApp: App {
    @StateObject private var studioListViewModel = StudioListViewModel()
    @StateObject private var reservationListViewModel = ReservationListViewModel()
    @StateObject private var tabbarManager = TabbarManager()
    
    init() {
        CacheManager.configureKingfisherCache()
    }
    
    var body: some Scene {
        WindowGroup {
            ToucheeseTabView()
                .environmentObject(studioListViewModel)
                .environmentObject(tabbarManager)
                .environmentObject(reservationListViewModel)
        }
    }
}
