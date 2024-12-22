//
//  TOUCHEESEApp.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // MARK: - 로그인 상태 확인
        let keychainManager = KeychainManager.shared
        let authManager = AuthenticationManager.shared
        
        let isExistingAccessToken = keychainManager.read(forAccount: .accessToken)
        isExistingAccessToken == nil ? authManager.failedAuthentication() : authManager.successfulAuthentication()
        
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
        #if DEBUG
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(deviceTokenString)
        #endif
        
        // APN 토큰을 명시적으로 FCM 등록 토큰에 매핑하는 코드
        Messaging.messaging().apnsToken = deviceToken
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate { }


extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        #if DEBUG
        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken)
        #endif
        
        Task {
            try await NetworkManager.shared.postDeviceTokenRegistrationData(
                deviceTokenRegistrationRequest: DeviceTokenRegistrationRequest(
                    memberId: 1,
                    deviceToken: fcmToken ?? ""
                )
            )
        }
    }
}


@main
struct TOUCHEESEApp: App {
    @StateObject private var studioListViewModel = StudioListViewModel()
    @StateObject private var reservationListViewModel = ReservationListViewModel()
    @StateObject private var navigationManager = NavigationManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        CacheManager.configureKingfisherCache()
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ToucheeseTabView()
                .environmentObject(studioListViewModel)
                .environmentObject(reservationListViewModel)
                .environmentObject(navigationManager)
                .preferredColorScheme(.light)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }
}
