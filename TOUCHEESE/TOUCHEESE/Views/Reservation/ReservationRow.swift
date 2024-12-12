//
//  ReservationRow.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import SwiftUI

struct ReservationRow: View {
    let reservation: Reservation
    private var status: ReservationStatus {
        ReservationStatus(rawValue: reservation.reservationStatus)!
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            ProfileImageView(imageURL: reservation.studioProfileImageURL, size: 40)
            
            VStack(alignment: .leading) {
                Text(reservation.studioName)
                    .fontWeight(.bold)
                
                Label(reservation.reservationDate, systemImage: "calendar")
                
                Label(reservation.reservationTimeString, systemImage: "clock")
            }
            
            Spacer()
            
            Text(status.description)
                .foregroundStyle(status.color.font)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(status.color.background)
                }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.tcLightyellow)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        ReservationRow(reservation: Reservation.sample)
        ReservationRow(reservation: Reservation.sample)
        ReservationRow(reservation: Reservation.sample)
    }
    .background(Color.tcGray01)
}
