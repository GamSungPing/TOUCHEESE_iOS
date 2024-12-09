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
    
}
