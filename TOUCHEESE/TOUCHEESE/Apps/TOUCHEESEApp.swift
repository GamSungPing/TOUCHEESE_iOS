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
    
    var body: some Scene {
        WindowGroup {
            ToucheeseTabView()
                .environmentObject(studioListViewModel)
        }
    }
}
