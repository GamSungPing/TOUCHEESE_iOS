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
    @State private var isPushingStudioDetailView = false
    
    var body: some View {
        let reservation = viewModel.reservation
        let reservationDetail = viewModel.reservationDetail
        
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
                
                // TODO: - 버튼 변경 필요
                HStack(spacing: 10) {
                    NavigationLink(value: viewModel.reservedStudio) {
                        Text("스튜디오 홈")
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.tcLightgray)
                            }
                    }
                    
                    if viewModel.isShowingReservationCancelButton() {
                        Button {
                            isShowingReservationCancelAlert.toggle()
                        } label: {
                            Text("예약 취소하기")
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 21)
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
        .alert(
            "예약을 취소하시겠습니까?",
            isPresented: $isShowingReservationCancelAlert
        ) {
            Button(role: .destructive) {
                dismiss()
                
                Task {
                    await viewModel.cancelReservation(reservationID: reservation.id)
                    await reservationListViewModel.fetchReservations()
                }
            } label: {
                Text("취소하기")
            }
        }
    }
    
    private var reservationStatusInfoView: some View {
        VStack {
            Text(" ※ 예약 상태는 아래와 같습니다.")
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
