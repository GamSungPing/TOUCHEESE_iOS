//
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
    
    init() {
        calTotalPrice()
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
        for option in productDetail.productOptions {
            if selectedOptionIDArray.contains(option.id) {
                totalPrice += option.price
            }
        }
        
        self.totalPrice = totalPrice
    }
}
