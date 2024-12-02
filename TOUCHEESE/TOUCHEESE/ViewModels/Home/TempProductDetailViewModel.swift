//  tembProductDetailViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/29/24.
//

import Foundation
import SwiftUI

final class TempProductDetailViewModel: ObservableObject {
    // MARK: - Data
    let product: Product = Product.sample1
    let productDetail: ProductDetail = ProductDetail.sample1
    let tempOpenTime = "11:00"
    let tempCloseTime = "17:00"
    let tempHolidays: [Int] = [1, 7]
    
    // 선택된 옵션의 ID Set
    private var selectedOptionIDArray: Set<Int> = [] {
        didSet {
            calTotalPrice()
        }
    }
    
    // 추가 인원 변수
    @Published private(set) var addPeopleCount: Int = 0 {
        didSet {
            calTotalPrice()
        }
    }
    
    // 총 가격
    @Published private(set) var totalPrice: Int = 0
    
    // 영업 시간 배열
    @Published private(set) var businessHour: [String] = []
    
    // 예약한 날짜
    @Published private(set) var reservationDate: Date?
    
    // 선택된 날짜
    var selectedDate: Date = Date()
    
    // 선택된 시간
    private var selectedTime: Date? {
        didSet {
            calReservationDate()
        }
    }
    
    init() {
        calTotalPrice()
        calBusinessHour()
    }
    
    // MARK: - Input
    func increaseAddPeopleCount() {
        addPeopleCount += 1
    }
    
    func decreaseAddPeopleCount() {
        if addPeopleCount > 0 {
            addPeopleCount -= 1
        }
    }
    
    func optionChanged(isSelected: Bool, id: Int) {
        if isSelected {
            selectedOptionIDArray.insert(id)
        } else {
            selectedOptionIDArray.remove(id)
        }
    }
    
    func selectDate(date: Date) {
        selectedDate = date
    }
    
    func selectTime(time: String) {
        selectedTime = time.toDate(dateFormat: .hourMinute)
    }
    
    // MARK: - Output
    func getAddPeoplePrice() -> String {
        guard let addPeoplePrice = productDetail.addPeoplePrice?.moneyStringFormat else { return "" }
        return addPeoplePrice
    }
    
    // MARK: - Logic
    private func calTotalPrice() {
        var totalPrice: Int = 0
        
        // 상품 기본 가격 추가
        totalPrice += product.price
        
        // 단체 인원별 가격 추가
        totalPrice += (productDetail.addPeoplePrice ?? 0) * addPeopleCount
        
        // 옵션 별 상품 가격 추가
        for option in productDetail.parsedProductOptions {
            if selectedOptionIDArray.contains(option.id) {
                totalPrice += option.price
            }
        }
        
        self.totalPrice = totalPrice
    }
    
    private func calBusinessHour() {
        let calendar = Calendar.current
        
        guard let openTime = tempOpenTime.toDate(dateFormat: .hourMinute) else { return }
        guard let closeTime = tempCloseTime.toDate(dateFormat: .hourMinute) else { return }
        guard let hourDifference = calendar.dateComponents([.hour], from: openTime, to: closeTime).hour else { return }
        
        var times: [String] = []
        
        for index in 0...(hourDifference - 1) {
            if let nextTime = calendar.date(byAdding: .hour, value: index, to: openTime) {
                times.append(DateFormat.hourMinute.toDateFormatter().string(from: nextTime))
            }
        }
        
        businessHour = times
    }
    
    private func calReservationDate() {
        guard let selectedTime else { return }
        
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        
        var reservationDate = DateComponents()
        reservationDate.year = dateComponents.year
        reservationDate.month = dateComponents.month
        reservationDate.day = dateComponents.day
        reservationDate.hour = timeComponents.hour
        reservationDate.minute = timeComponents.minute
                
        self.reservationDate = calendar.date(from: reservationDate)
    }
}
