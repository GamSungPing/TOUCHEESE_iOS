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
        do {
            reservations = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [self] token in
                try await networkManager.getReservationListDatas(
                    accessToken: token,
                    memberID: 16
                )
            }
        } catch {
            print("Reservation List Fetch Error: \(error.localizedDescription)")
            authManager.failedAuthentication()
            print("Logout")
        }
    }
    
    @MainActor
    func fetchPastReservations() async {
        do {
            reservations = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [self] token in
                try await networkManager.getReservationListDatas(
                    accessToken: token,
                    memberID: 16,
                    isPast: true
                )
            }
        } catch {
            print("Past Reservation List Fetch Error: \(error.localizedDescription)")
            authManager.failedAuthentication()
            print("Logout")
        }
    }
    
}
