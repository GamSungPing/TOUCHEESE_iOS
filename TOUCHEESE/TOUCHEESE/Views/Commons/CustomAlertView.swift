//
//  CustomAlertView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/14/24.
//

import SwiftUI

enum AlertType {
    case reservationCancel
    case reservationCancelComplete
    
    var description: String {
        switch self {
        case .reservationCancel: "정말 예약을 취소하시겠습니까?"
        case .reservationCancelComplete: "예약이 취소되었습니다."
        }
    }
}

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    let alertType: AlertType
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.tcGray09
                .opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text(alertType.description)
                    .foregroundStyle(.tcGray09)
                    .font(.pretendardMedium16)
                
                switch alertType {
                // 버튼의 액션이 필요한 경우
                case .reservationCancel:
                    HStack(spacing: 12) {
                        FillBottomButton(
                            isSelectable: true,
                            title: "확인",
                            height: 48
                        ) {
                            isPresented.toggle()
                            action()
                        }
                        
                        FillBottomButton(
                            isSelectable: true,
                            title: "취소",
                            height: 48,
                            backgroundColor: .tcGray02
                        ) {
                            isPresented.toggle()
                        }
                    }
                // Alert Dismiss만 필요한 경우
                case .reservationCancelComplete:
                    FillBottomButton(
                        isSelectable: true,
                        title: "확인",
                        height: 48
                    ) {
                        isPresented.toggle()
                        action()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .padding(.bottom, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
            )
            .padding(.horizontal, 44)
        }
    }
}

#Preview {
    VStack {
        CustomAlertView(
            isPresented: .constant(true),
            alertType: .reservationCancel
        ) {
            print("액션")
        }
        
        CustomAlertView(
            isPresented: .constant(true),
            alertType: .reservationCancelComplete
        ) {
            print("액션")
        }
    }
}
