//
//  TempNavigationManager.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/12/24.
//

import Foundation
import SwiftUI

class TempNavigationManager: ObservableObject {
    @Published var homePath: [ViewType] = []
    @Published var tabNumber: Int = 0
    
    private(set) var homeResultViewMaterial: HomeResultViewMaterial?
    private(set) var studioDetailViewMaterial: StudioDetailViewMaterial?
    private(set) var productDetailViewMaterial: ProductDetailViewMaterial?
    private(set) var reservationConfirmViewMaterial: ReservationConfirmViewMaterial?
    
    func goFirstView() {
        homePath.removeAll()
    }
    
    func goFirstViewAndSecondTap() {
        homePath.removeAll()
        tabNumber = 1
    }
    
    @ViewBuilder
    func buildView(viewType: ViewType) -> some View {
        switch viewType {
        case .homeResultView:
            HomeResultView(concept: self.homeResultViewMaterial!.concept)
        case .studioDetailView:
            StudioDetailView(viewModel: self.studioDetailViewMaterial!.viewModel)
        case .productDetailView:
            ProductDetailView(productDetailViewModel: self.productDetailViewMaterial!.viewModel)
        case .reservationConfirmView:
            ReservationConfirmView(reservationViewModel: self.reservationConfirmViewMaterial!.viewModel)
        case .reservationCompleteView:
            ReservationCompleteView()
        }
    }
    
    func appendPath(viewType: ViewType, viewMaterial: ViewMaterial?) {
        switch viewType {
        case .homeResultView:
            self.homeResultViewMaterial = viewMaterial as? HomeResultViewMaterial
            homePath.append(.homeResultView)
        case .studioDetailView:
            self.studioDetailViewMaterial = viewMaterial as? StudioDetailViewMaterial
            homePath.append(.studioDetailView)
        case .productDetailView:
            self.productDetailViewMaterial = viewMaterial as? ProductDetailViewMaterial
            homePath.append(.productDetailView)
        case .reservationConfirmView:
            self.reservationConfirmViewMaterial = viewMaterial as? ReservationConfirmViewMaterial
            homePath.append(.reservationConfirmView)
        case .reservationCompleteView:
            homePath.append(.reservationCompleteView)
        }
    }
}
