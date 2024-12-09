//
//  ReservationDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

final class ReservationDetailViewModel: ObservableObject {
    
    // MARK: - Data
    @Published private(set) var reservation: Reservation
    @Published private(set) var reservationDetail: ReservationDetail = ReservationDetail.sample
    
    let networkManager = NetworkManager.shared
    
    init(reservation: Reservation) {
        self.reservation = reservation
        
        // TODO: - API를 통해 ReservationDetail Fetch 하기
        Task {
            await fetchReservationDetail(reservationID: reservation.id)
        }
    }
    
    // MARK: - Logic
    func isShowingReservationCancelButton() -> Bool {
        switch reservation.reservationStatus {
        case ReservationStatus.complete.rawValue, ReservationStatus.cancel.rawValue:
            false
        case ReservationStatus.waiting.rawValue, ReservationStatus.confirm.rawValue:
            true
        default:
            false
        }
    }
    
    @MainActor
    func fetchReservationDetail(reservationID: Int) async {
        do {
            reservationDetail = try await networkManager.getReservationDetailData(reservationID: reservationID)
        } catch {
            print("ReservationDetail Fetch Error: \(error.localizedDescription)")
        }
    }
    
}
