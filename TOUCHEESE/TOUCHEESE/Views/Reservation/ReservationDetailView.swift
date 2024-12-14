//
//  ReservationDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import SwiftUI

struct ReservationDetailView: View {
    @EnvironmentObject private var tabbarManager: TabbarManager
    @EnvironmentObject private var reservationListViewModel: ReservationListViewModel
    @StateObject var viewModel: ReservationDetailViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingReservationCancelAlert = false
    @State private var isShowingReservationCancelCompleteAlert = false
    @State private var isPushingStudioDetailView = false
    
    var body: some View {
        let reservation = viewModel.reservation
        let reservationDetail = viewModel.reservationDetail
        
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ReservationInfoView(
                        studioName: reservation.studioName,
                        studioAddress: reservationDetail.studioAddress,
                        reservationStatus: ReservationStatus(rawValue: reservation.reservationStatus) ?? .waiting,
                        userName: reservationDetail.memberName,
                        reservationDateString: reservation.reservationDate.toReservationDateType,
                        reservationTimeString: reservation.reservationTimeString
                    )
                    
                    // TODO: - 서버에 내용 반영 후 추가 예정
                    /*
                    ReservationProductView(
                        studioName: reservation.studioName,
                        productName: productName,
                        productImageURL: productImageURL,
                        productPriceString: productPriceString,
                        productOptions: productOptions,
                        addPeopleCount: addPeopleCount,
                        addPeoplePrice: addPeoplePrice
                    )
                   
                    DividerView(color: .tcGray01, height: 8)
                    
                    // 결제 정보 뷰
                    PayInfoView(
                        productName: productName,
                        productOptions: productOptions,
                        addPeopleCount: addPeopleCount,
                        addPeoplePrice: addPeoplePrice,
                        totalPriceString: totalPriceString,
                        addPeopleTotalPriceString: addpeopleTotalPriceString
                    )
                     */
                    
                    reservationStatusInfoView
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                    
                    HStack(spacing: 10) {
                        FillBottomButton(isSelectable: true, title: "스튜디오 홈", height: 48) {
                            // TODO: - 네비게이션 Path 추가 필요
                        }
                        
                        if viewModel.isShowingReservationCancelButton() {
                            StrokeBottomButton(title: "예약 취소하기") {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    isShowingReservationCancelAlert.toggle()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 21)
                    .padding(.horizontal, 16)
                    
                    Color.clear
                        .frame(height: 21)
                }
            }
            .customNavigationBar(centerView: {
                Text("예약 내역")
                    .modifier(NavigationTitleModifier())
            }, leftView: {
                Button {
                    dismiss()
                } label: {
                    NavigationBackButtonView()
                }
            })
            
            if isShowingReservationCancelAlert {
                CustomAlertView(isPresented: $isShowingReservationCancelAlert, alertType: .reservationCancel) {
                    isShowingReservationCancelCompleteAlert.toggle()
                    
                    Task {
                        await viewModel.cancelReservation(reservationID: reservation.id)
                        await reservationListViewModel.fetchReservations()
                        await reservationListViewModel.fetchPastReservations()
                    }
                }
            }
            
            if isShowingReservationCancelCompleteAlert {
                CustomAlertView(isPresented: $isShowingReservationCancelCompleteAlert, alertType: .reservationCancelComplete) {
                    dismiss()
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(.tcGray01)
        .navigationDestination(for: Studio.self) { studio in
            StudioDetailView(
                viewModel: StudioDetailViewModel(studio: studio)
            )
        }
        .toolbar(tabbarManager.isHidden ? .hidden : .visible, for: .tabBar)
        .onAppear {
            tabbarManager.isHidden = true
        }
    }
    
    private var reservationStatusInfoView: some View {
        VStack {
            Text("※ 예약 상태는 아래와 같습니다.")
                .foregroundStyle(.tcBlue)
                .font(.pretendardSemiBold16)
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(ReservationStatus.allCases, id: \.rawValue) { status in
                    VStack(alignment: .leading, spacing: 10) {
                        ReservationStatusView(status)
                        
                        Text(status.description)
                            .font(.pretendardRegular(12))
                            .foregroundStyle(.tcGray06)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(6)
                    }
                }
            }
            .padding(.top, 24)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.tcGray02)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.tcGray03, lineWidth: 0.92)
                }
        }
    }
}

#Preview {
    NavigationStack {
        ReservationDetailView(
            viewModel: ReservationDetailViewModel(
                reservation: Reservation.sample
            )
        )
        .environmentObject(TabbarManager())
    }
}
