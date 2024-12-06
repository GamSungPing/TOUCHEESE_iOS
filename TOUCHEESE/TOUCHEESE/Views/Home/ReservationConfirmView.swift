//
//  ReservationConfirmView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import SwiftUI

struct ReservationConfirmView: View {
    // MARK: - TempDatas
    let studioName = "마루 스튜디오"
    let address = "서울시 땡땡구 땡땡번지 땡떙"
    let userName = "김마루"
    let product: [String] = ["프로필 촬영", "뽀샵?", "전체 출력"]
    let productPrice: [Int] = [10000, 20000, 30000]
    let totalPrice: Int = 130000
    let date: String = "2024년 12월 7일 13시"
        
    @State var userEmail: String = ""
    @State var userPhone: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                Text("예약 정보")
                    .font(.title)
                
                Text("스튜디오: \(studioName)")
                Text("주소: \(address)")
                Text("예약자: \(userName)")
                
                ForEach(product.indices, id: \.self) { index in
                    HStack {
                        Text("옵션\(index + 1): \(product[index])")
                        Text("(\(productPrice[index]) 원)")
                    }
                }
                
                Text("\(totalPrice)")
                Text(date)
                    .padding(.bottom, 60)
                
                
                Text("연락받을 곳")
                    .font(.title)
                HStack {
                    Text("이메일")
                    TextField("이메일을 입력해주세요", text: $userEmail)
                }
                
                HStack {
                    Text("전화번호")
                    TextField("전화번호를 입력해주세요", text: $userPhone)
                }
            }
            .padding(.leading, 30)
            
            Spacer()
            
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.tcYellow)
                    .frame(width: .screenWidth - 60, height: 40)
                    .overlay {
                        Text("예약 하기")
                    }
                    .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    ReservationConfirmView()
}
