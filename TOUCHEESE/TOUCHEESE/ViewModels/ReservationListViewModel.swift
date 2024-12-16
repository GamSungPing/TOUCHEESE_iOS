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
            // TODO: - 추후 맴버 ID 변경, 현재는 고정값
            reservations = try await networkManager.getReservationListDatas(memberID: 1)
        } catch {
            print("Reservation List Fetch Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchPastReservations() async {
        do {
            // TODO: - 추후 맴버 ID 변경, 현재는 고정값
            pastReservations = try await networkManager.getReservationListDatas(memberID: 1, isPast: true)
        } catch {
            print("Past Reservation List Fetch Error: \(error.localizedDescription)")
        }
    }
    
}
