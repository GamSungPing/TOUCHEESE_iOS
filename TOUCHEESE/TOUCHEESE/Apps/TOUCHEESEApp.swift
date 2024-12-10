//
//  TOUCHEESEApp.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // MARK: - Firebase 관련 설정
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // MARK: - Push Notification 권한 설정
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        // 앱에서 알림 권한을 요청하는 메서드
        center.requestAuthorization(options: authOptions) { granted, error in
            guard error == nil else {
                print("Error while requesting permission for notifications.")
                return
            }
            
            if granted {
                print("Authorization granted.")
                DispatchQueue.main.async {
                    // APNs에 등록
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Authorization denied or undetermined.")
            }
        }
        
        return true
    }
    
    // 디바이스가 APNs 등록에 실패했을 때 호출되는 메서드
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: any Error
    ) {
        print(error.localizedDescription)
    }
    
    // 디바이스가 APNs 등록에 성공했을 때 호출되는 메서드
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("🪙🪙🪙🪙", deviceTokenString)
        
        Messaging.messaging().apnsToken = deviceToken
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate { }


extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken)
    }
}


@main
struct TOUCHEESEApp: App {
    @StateObject private var studioListViewModel = StudioListViewModel()
    @StateObject private var reservationListViewModel = ReservationListViewModel()
    @StateObject private var tabbarManager = TabbarManager()
    @StateObject private var navigationManager = NavigationManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        CacheManager.configureKingfisherCache()
    }
    
    var body: some Scene {
        WindowGroup {
            ToucheeseTabView()
                .environmentObject(studioListViewModel)
                .environmentObject(tabbarManager)
                .environmentObject(reservationListViewModel)
                .environmentObject(navigationManager)
        }
    }
}
