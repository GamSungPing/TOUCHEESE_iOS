//
//  ReservationDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import SwiftUI

struct ReservationDetailView: View {
    let reservation: Reservation
    
    var body: some View {
        Text(reservation.studioName)
    }
}

#Preview {
    ReservationDetailView(reservation: Reservation.sample)
}
