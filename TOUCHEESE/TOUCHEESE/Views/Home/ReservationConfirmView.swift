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
        let productOptions = tempReservationViewModel.productOptions
        let totalPrice: Int = tempReservationViewModel.totalPrice
        let date: String = tempReservationViewModel.reservationDate.toString(format: .yearMonthDay)
        
        VStack {
            VStack(alignment: .leading) {
                
                Text("예약 정보")
                    .font(.title)
                
                Text("스튜디오: \(studioName)")
                Text("주소: \(address)")
                Text("예약자: \(userName)")
                
                ForEach(productOptions.indices, id: \.self) { index in
                    HStack {
                        Text("옵션\(index + 1): \(productOptions[index].name)")
                        Text("(\(productOptions[index].price) 원)")
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
                        .keyboardType(.emailAddress)
                }
                
                HStack {
                    Text("전화번호")
                    TextField("전화번호를 입력해주세요", text: $tempReservationViewModel.userPhone)
                        .keyboardType(.numberPad)
                }
            }
            .padding(.leading, 30)
            
            Spacer()
            
            Button {
                Task {
                    await tempReservationViewModel.requestStudioReservation()
                }
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(tempReservationViewModel.isUserInputInfoValid() ? .tcYellow : .tcLightgray)
                    .frame(width: .screenWidth - 60, height: 40)
                    .overlay {
                        Text("예약 하기")
                    }
                    .padding(.bottom, 30)
            }
            .disabled(!tempReservationViewModel.isUserInputInfoValid())
        }
        .onChange(of: tempReservationViewModel.userPhone) { newValue in
            tempReservationViewModel.userPhone = newValue.filter { $0.isNumber }
        }
    }
}

#Preview {
    ReservationConfirmView()
}
