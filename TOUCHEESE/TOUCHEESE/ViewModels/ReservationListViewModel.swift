//
//  ReservationListViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

final class ReservationListViewModel: ObservableObject {
    
    @Published private(set) var reservations: [Reservation] = []
    @Published private(set) var pastReservations: [Reservation] = []
    
    let authManager = AuthenticationManager.shared
    let networkManager = NetworkManager.shared
    
    init() {
        Task {
            await fetchReservations()
            await fetchPastReservations()
        }
    }
    
    @MainActor
    func fetchReservations() async {
        guard authManager.authStatus == .authenticated else { return }
        
        do {
            reservations = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [self] token in
                if let memberId = authManager.memberId {
                    return try await networkManager.getReservationListDatas(
                        accessToken: token,
                        memberID: memberId
                    )
                } else {
                    authManager.failedAuthentication()
                    return []
                }
            }
        } catch {
            print("Reservation List Fetch Error: \(error.localizedDescription)")
            authManager.failedAuthentication()
            print("Logout")
        }
    }
    
    @MainActor
    func fetchPastReservations() async {
        guard authManager.authStatus == .authenticated else { return }
        
        do {
            reservations = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [self] token in
                if let memberId = authManager.memberId {
                    return try await networkManager.getReservationListDatas(
                        accessToken: token,
                        memberID: memberId,
                        isPast: true
                    )
                } else {
                    authManager.failedAuthentication()
                    return []
                }
            }
        } catch {
            print("Past Reservation List Fetch Error: \(error.localizedDescription)")
            authManager.failedAuthentication()
            print("Logout")
        }
    }
    
}
