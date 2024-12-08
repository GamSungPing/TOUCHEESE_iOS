//
//  ReservationListView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/7/24.
//

import SwiftUI

struct ReservationListView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack {
            Picker("ReservationList", selection: $selectedIndex) {
                Text("예약 일정").tag(0)
                Text("이전 내역").tag(1)
            }
            .pickerStyle(.segmented)
            
            ScrollView(.vertical) {
                Color.clear
                    .frame(height: 5)
                
                LazyVStack(spacing: 15) {
                    if selectedIndex == 0 {
                        ReservationRow()
                        ReservationRow()
                        ReservationRow()
                    } else {
                        Text("Reservation Card3")
                        Text("Reservation Card4")
                        Text("Reservation Card5")
                    }
                    
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ReservationListView()
}
