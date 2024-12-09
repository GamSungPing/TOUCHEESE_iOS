//
//  ReservationListView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/7/24.
//

import SwiftUI

struct ReservationListView: View {
    @EnvironmentObject private var tabbarManager: TabbarManager
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
                FilteredReservationListView(
                    reservations: viewModel.reservations
                ) {
                    reservationEmptyView(description: "예약 일정이 없습니다.")
                } refreshAction: {
                    Task {
                        await viewModel.fetchReservations()
                    }
                }

            } else {
                FilteredReservationListView(
                    reservations: viewModel.pastReservations
                ) {
                    reservationEmptyView(description: "지난 내역이 없습니다.")
                } refreshAction: {
                    Task {
                        await viewModel.fetchPastReservations()
                    }
                }

            }
        }
        .padding(.horizontal)
        .navigationDestination(for: Reservation.self) { reservation in
            ReservationDetailView(
                viewModel: ReservationDetailViewModel(reservation: reservation)
            )
        }
        .onAppear {
            tabbarManager.isHidden = false
        }
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


fileprivate struct FilteredReservationListView<Content>: View where Content: View {
    @State var reservations: [Reservation]
    @ViewBuilder let emptyView: Content
    let refreshAction: () -> Void
    
    var body: some View {
        if reservations.isEmpty {
            emptyView
        } else {
            ScrollView(.vertical) {
                Color.clear
                    .frame(height: 5)
                
                LazyVStack(spacing: 15) {
                    ForEach(reservations) { reservation in
                        NavigationLink(value: reservation) {
                            ReservationRow(reservation: reservation)
                        }
                    }
                }
            }
            .refreshable {
                refreshAction()
            }
        }
    }
}

#Preview {
    ReservationListView()
        .environmentObject(ReservationListViewModel())
        .environmentObject(TabbarManager())
}
