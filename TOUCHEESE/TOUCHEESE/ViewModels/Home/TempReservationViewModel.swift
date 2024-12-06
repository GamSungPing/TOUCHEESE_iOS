//
//  TempReservationViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import Foundation

final class TempReservationViewModel: ObservableObject {
    // MARK: - TempDatas
    let studioName = "마루 스튜디오"
    let address = "서울시 땡땡구 땡땡번지 땡떙"
    let userName = "김마루"
    let product: [String] = ["프로필 촬영", "뽀샵?", "전체 출력"]
    let productPrice: [Int] = [10000, 20000, 30000]
    let totalPrice: Int = 130000
    let date: String = "2024년 12월 7일 13시"
        
    @Published var userEmail: String = ""
    @Published var userPhone: String = ""
    
    
    
    
    
}
