//
//  ReservationListView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/7/24.
//

import SwiftUI

struct ReservationListView: View {
    @EnvironmentObject private var tabbarManager: TabbarManager
    @EnvironmentObject private var tempNavigationManager: TempNavigationManager
    @EnvironmentObject private var viewModel: ReservationListViewModel
    
    @State private var selectedIndex = 0
    @State private var activeTab: SegmentedTab = .reservation
    
    var body: some View {
        VStack {
            ReservationCustomSegmentedControl(
                tabs: SegmentedTab.allCases,
                activeTab: $activeTab
            )
            
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
        .customNavigationBar {
            Text("예약 내역")
                .modifier(NavigationTitleModifier())
        }
        .onAppear {
            tabbarManager.isHidden = false
        }
        .background(.tcGray01)
    }
    
    private func reservationEmptyView(description: String) -> some View {
        VStack {
            Spacer()
            
            Image(.tcEmptyIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 84)
                .foregroundStyle(.tcGray03)
            
            Text("\(description)")
                .font(.pretendardMedium(18))
                .foregroundStyle(.tcGray04)
                .padding(.top, 18)
            
            Spacer()
        }
        .padding()
    }
}


fileprivate struct FilteredReservationListView<Content>: View where Content: View {
    @EnvironmentObject private var tempNavigationManager: TempNavigationManager
    
    var reservations: [Reservation]
    @ViewBuilder let emptyView: Content
    let refreshAction: () -> Void
    
    var body: some View {
        if reservations.isEmpty {
            emptyView
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                Color.clear
                    .frame(height: 20)
                
                LazyVStack(spacing: 8) {
                    ForEach(reservations) { reservation in
                        Button {
                            tempNavigationManager.appendPath(viewType: .reservationDetailView, viewMaterial: ReservationDetailViewMaterial(viewModel: ReservationDetailViewModel(reservation: reservation)))
                        } label: {
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
