//
//  ReservationCompleteView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/9/24.
//

import SwiftUI

struct ReservationCompleteView: View {
    var reservationMessage = """
    예약이 신청되었습니다.
    
    스튜디오와 최종 확인 후 예약이
    확정되거나 취소되면 알림을
    받을 수 있습니다.
    """
    
    var body: some View {
        VStack {
            Text(reservationMessage)
                .padding(.bottom, 60)
            
            Button {
                
            } label: {
                Rectangle()
                    .foregroundStyle(Color.tcLightgray)
                    .overlay {
                        Text("예약 일정 확인하러 가기")
                            .foregroundStyle(Color.black)
                    }
                    .frame(width: 200, height: 30)
            }
            
            Button {
                
            } label: {
                Rectangle()
                    .foregroundStyle(Color.tcLightgray)
                    .overlay {
                        Text("확인")
                            .foregroundStyle(Color.black)
                    }
                    .frame(width: 200, height: 30)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ReservationCompleteView()
    }
}
