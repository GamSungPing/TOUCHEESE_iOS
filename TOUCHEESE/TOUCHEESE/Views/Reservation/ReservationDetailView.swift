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
                    // TODO: - 공통 뷰 적용 예정
                    Text("스튜디오 정보")
                        .fontWeight(.semibold)
                        .font(.title2)
                    Text("스튜디오: \(reservation.studioName)")
                    Text("주소: \(reservationDetail.studioAddress)")
                        .padding(.bottom)
                    
                    Text("예약 정보")
                        .fontWeight(.semibold)
                        .font(.title2)
                    Text("예약 날짜: \(reservation.reservationDate)")
                    Text("예약 시간: \(reservation.reservationTimeString)")
                    Text("예약자 성함: \(reservationDetail.memberName)")
                    Text("예약자 전화번호: \(reservationDetail.phoneNumber)")
                    Text("예약자 이메일: \(reservationDetail.memberEmail)")
                        .padding(.bottom)
                    
                    Text("예약 상품")
                        .fontWeight(.semibold)
                        .font(.title2)
                    ForEach(
                        reservationDetail.parsedProductOptions.indices,
                        id: \.self
                    ) { index in
                        HStack {
                            Text("옵션\(index + 1): \(reservationDetail.parsedProductOptions[index].name)")
                            Text("(\(reservationDetail.parsedProductOptions[index].price)원)")
                        }
                    }
                    Text("결제 예정 금액: \(reservationDetail.totalPrice)원")
                    
                    reservationStatusInfoView
                    
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
                    
                    Color.clear
                        .frame(height: 21)
                }
                .padding(.horizontal)
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
