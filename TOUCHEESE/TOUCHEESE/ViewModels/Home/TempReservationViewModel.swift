//
//  TempReservationViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import Foundation

final class TempReservationViewModel: ObservableObject {
    let networkmanager = NetworkManager.shared
    
    // MARK: - TempDatas
    let studioName = "마루 스튜디오"
    let address = "서울시 땡땡구 땡땡번지 땡떙"
    let userName = "김마루"
    
    // MARK: - 스튜디오 예약 요청에 필요한 데이터들
    let memberId = 1
    let studioId: Int = 6
    let reservationDate: Date = Date()
    let productId: Int = 1
    let productOptions: [ProductOption] = [ProductOption.sample1, ProductOption.sample2, ProductOption.sample3]
    let totalPrice: Int = 130000
    @Published var userEmail: String = ""
    @Published var userPhone: String = ""
    
    private(set) var reservationResponseData: ReservationResponse? = nil
    
    /// 사용자가 입력한 정보(이메일, 전화번호)가 유효한지 검사하는 함수
    func isUserInputInfoValid() -> Bool {
        var isValid: Bool = true
        
        // 사용자가 입력한 이메일이 유효한지 검사
        if !userEmail.contains("@") {
            isValid = false
            return isValid
        }
        
        // 사용자가 입력한 비밀번호가 유효한지 검사
        if !(userPhone.count == 11) {
            isValid = false
            return isValid
        }
        
        return isValid
    }
    
    /// 스튜디오 예약 요청을 보내는 함수
    func requestStudioReservation() async {
        let reservationRequestType = ReservationRequest(
            memberId: memberId,
            studioId: studioId,
            reservationDate: reservationDate,
            productId: productId,
            productOptions: productOptions,
            totalPrice: totalPrice,
            phoneNumber: userPhone,
            email: userEmail
        )
        
        do {
            reservationResponseData = try await networkmanager.reserveStudio(reservationRequest: reservationRequestType)
            print("\(reservationResponseData)")
        } catch {
            print("requestStudioReservation Error: \(error.localizedDescription)")
        }
    }
}
