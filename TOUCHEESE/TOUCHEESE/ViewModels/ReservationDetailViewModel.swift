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
    @Published private(set) var reservedStudio: Studio = Studio.sample
    
    let networkManager = NetworkManager.shared
    
    init(reservation: Reservation) {
        self.reservation = reservation
        
        Task {
            await fetchReservationDetail(reservationID: reservation.id)
            await fetchReservedStudio()
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
    
    @MainActor
    func cancelReservation(reservationID: Int) async {
        do {
            // TODO: - 추후 memberID 수정, 현재는 고정값으로 사용
            try await networkManager.deleteReservationData(reservationID: reservationID, memberID: 1)
        } catch {
            print("Reservation Cancel Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func fetchReservedStudio() async {
        do {
            reservedStudio = try await networkManager.getStudioData(studioID: reservationDetail.studioId)
        } catch {
            print("Reserved Studio Fetch Error: \(error.localizedDescription)")
        }
    }
    
}
