//
//  TOUCHEESEApp.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

@main
struct TOUCHEESEApp: App {
    @StateObject private var studioListViewModel = StudioListViewModel()
    @StateObject private var tempProductDetailViewModel = TempProductDetailViewModel()
    
    init() {
        CacheManager.configureKingfisherCache()
    }
    
    var body: some Scene {
        WindowGroup {
            ToucheeseTabView()
                .environmentObject(studioListViewModel)
                .environmentObject(tempProductDetailViewModel)
        }
    }
}
