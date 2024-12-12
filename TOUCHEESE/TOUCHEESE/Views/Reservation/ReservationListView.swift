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
    @State private var activeTab: SegmentedTab = .reservation
    
    var body: some View {
        VStack {
            ReservationCustomSegmentedControl(
                tabs: SegmentedTab.allCases,
                activeTab: $activeTab
            )
            
            Spacer(minLength: 0)
            
            switch activeTab {
            case .reservation:
                FilteredReservationListView(
                    reservations: viewModel.reservations
                ) {
                    reservationEmptyView(description: "예약 일정이 없습니다.")
                } refreshAction: {
                    Task {
                        await viewModel.fetchReservations()
                    }
                }
            case .history:
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
    var reservations: [Reservation]
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
            .animation(.easeInOut, value: reservations)
        }
    }
}


fileprivate struct ReservationCustomSegmentedControl: View {
    var tabs: [SegmentedTab]
    @Binding var activeTab: SegmentedTab
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(tabs, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .font(Font.pretendardSemiBold14)
                    .foregroundStyle(activeTab == tab ? .tcGray10 : .tcGray05)
                    .animation(.snappy, value: activeTab)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.interactiveSpring()) {
                            activeTab = tab
                        }
                    }
                    .background(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(activeTab == tab ? .white  : .tcGray02)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.tcGray02)
        }
    }
}


fileprivate enum SegmentedTab: String, CaseIterable {
    case reservation = "예약 일정"
    case history = "이전 내역"
}


#Preview {
    ReservationListView()
        .environmentObject(ReservationListViewModel())
        .environmentObject(TabbarManager())
}
