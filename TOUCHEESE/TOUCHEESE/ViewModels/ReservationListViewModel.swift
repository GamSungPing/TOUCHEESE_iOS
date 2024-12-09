//
//  ReservationListViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

final class ReservationListViewModel: ObservableObject {
    
    @Published private(set) var reservations: [Reservation]
    @Published private(set) var pastReservations: [Reservation]
    
    init() {
        // TODO: - 추후에는 네트워크 통신으로 Reservations를 fetch할 예정
        self.reservations = Reservation.samples
        self.pastReservations = Reservation.samples
    }
    
}
