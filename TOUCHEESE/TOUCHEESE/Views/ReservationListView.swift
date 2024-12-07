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
                LazyVStack {
                    if selectedIndex == 0 {
                        Text("Reservation Card0")
                        Text("Reservation Card1")
                        Text("Reservation Card2")
                    } else {
                        Text("Reservation Card3")
                        Text("Reservation Card4")
                        Text("Reservation Card5")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ReservationListView()
}
