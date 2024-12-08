//
//  ReservationListView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/7/24.
//

import SwiftUI

struct ReservationListView: View {
    @EnvironmentObject private var viewModel: ReservationListViewModel
    
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack {
            Picker("ReservationList", selection: $selectedIndex) {
                Text("예약 일정").tag(0)
                Text("지난 내역").tag(1)
            }
            .pickerStyle(.segmented)
            
            if selectedIndex == 0 {
                if viewModel.reservations.isEmpty {
                    reservationEmptyView(description: "예약 일정이 없습니다.")
                } else {
                    ScrollView(.vertical) {
                        Color.clear
                            .frame(height: 5)
                        
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.reservations) { reservation in
                                ReservationRow(reservation: reservation)
                            }
                        }
                    }
                    .refreshable {
                        // TODO: - 새로운 내역 받아오기
                    }
                }
            } else {
                if viewModel.lastReservations.isEmpty {
                    reservationEmptyView(description: "지난 내역이 없습니다.")
                } else {
                    ScrollView(.vertical) {
                        Color.clear
                            .frame(height: 5)
                        
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.lastReservations) { reservation in
                                ReservationRow(reservation: reservation)
                            }
                        }
                    }
                    .refreshable {
                        // TODO: - 새로운 내역 받아오기
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func reservationEmptyView(description: String) -> some View {
        VStack {
            Spacer()
            
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundStyle(Color.gray)
            
            Text("\(description)")
                .foregroundStyle(Color.gray)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ReservationListView()
        .environmentObject(ReservationListViewModel())
}
