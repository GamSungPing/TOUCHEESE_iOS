//
//  TempReservationViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import Foundation

final class TempReservationViewModel: ObservableObject {
    let networkmanager = NetworkManager.shared
    
    // MARK: - 받아올 RealDatas
    let studio: Studio
    let studioDetail: StudioDetail
    let product: Product
    let productDetail: ProductDetail
    let productOptions: [ProductOption]
    let reservationDate: Date
    let totalPrice: Int
    
    // MARK: - 멤버 임시 데이터
    let userName = "김마루"
    let memberId = 1
    
    @Published var userEmail: String = ""
    @Published var userPhone: String = ""
    
    private(set) var reservationResponseData: ReservationResponse? = nil
    
    // MARK: - Init
    init(
        studio: Studio,
        studioDetail: StudioDetail,
        product: Product,
        productDetail: ProductDetail,
        productOptions: [ProductOption],
        reservationDate: Date,
        totalPrice: Int
    ) {
        self.studio = studio
        self.studioDetail = studioDetail
        self.product = product
        self.productDetail = productDetail
        self.productOptions = productOptions
        self.reservationDate = reservationDate
        self.totalPrice = totalPrice
    }
    
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
            studioId: studio.id,
            reservationDate: reservationDate,
            productName: product.name,
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
