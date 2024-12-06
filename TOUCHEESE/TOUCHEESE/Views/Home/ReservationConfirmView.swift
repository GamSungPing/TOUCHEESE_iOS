//
//  ReservationConfirmView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import SwiftUI

struct ReservationConfirmView: View {
    // MARK: - TempDatas
    @StateObject private var tempReservationViewModel = TempReservationViewModel()
        
    var body: some View {
        let studioName = tempReservationViewModel.studioName
        let address = tempReservationViewModel.address
        let userName = tempReservationViewModel.userName
        let product: [String] = tempReservationViewModel.product
        let productPrice: [Int] = tempReservationViewModel.productPrice
        let totalPrice: Int = tempReservationViewModel.totalPrice
        let date: String = tempReservationViewModel.date
        
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
                    TextField("이메일을 입력해주세요", text: $tempReservationViewModel.userEmail)
                }
                
                HStack {
                    Text("전화번호")
                    TextField("전화번호를 입력해주세요", text: $tempReservationViewModel.userPhone)
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
