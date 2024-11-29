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
    
    // 추가 인원 변수
    @Published var addPeopleCount: Int = 0
    
    // MARK: - Input
    func increaseAddPeopleCount() {
        addPeopleCount += 1
    }
    
    func decreaseAddPeopleCount() {
        if addPeopleCount > 0 {
            addPeopleCount -= 1
        }
    }
}
