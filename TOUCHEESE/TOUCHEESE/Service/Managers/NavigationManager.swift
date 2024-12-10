//
//  NavigationManager.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/10/24.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var viewStack: [ViewType] = []
    @Published var tabNumber: Int = 0
    
    private(set) var homeResultViewMaterial: HomeResultViewMaterial?
    private(set) var studioDetailViewMaterial: StudioDetailViewMaterial?
    private(set) var productDetailViewMaterial: ProductDetailViewMaterial?
    private(set) var reservationConfirmViewMaterial: ReservationConfirmViewMaterial?
    
    func goFirstView() {
        viewStack.removeAll()
    }
    
    func goFirstViewAndSecondTap() {
        viewStack.removeAll()
        tabNumber = 1
    }
    
    func goHomeResultView(material: HomeResultViewMaterial) {
        self.homeResultViewMaterial = material
        viewStack.append(.homeResultView)
    }
    
    func goStudioDetailView(material: StudioDetailViewMaterial) {
        self.studioDetailViewMaterial = material
        viewStack.append(.studioDetailView)
    }
    
    func goProductDetailView(material: ProductDetailViewMaterial) {
        self.productDetailViewMaterial = material
        viewStack.append(.productDetailView)
    }
    
    func goReservationConfirmView(material: ReservationConfirmViewMaterial) {
        self.reservationConfirmViewMaterial = material
        viewStack.append(.reservationConfirmView)
    }
    
    func goReservationCompleteView() {
        viewStack.append(.reservationCompleteView)
    }
}
