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
    @Published var reservationPath: [ViewType] = []
    @Published var tabNumber: Int = 0
    
    private(set) var homeResultViewMaterial: HomeResultViewMaterial?
    private(set) var studioDetailViewMaterial: StudioDetailViewMaterial?
    private(set) var productDetailViewMaterial: ProductDetailViewMaterial?
    private(set) var reservationConfirmViewMaterial: ReservationConfirmViewMaterial?
    
    private(set) var reservationDetailViewMaterial: ReservationDetailViewMaterial?
    
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
            
        case .reservationDetailView:
            ReservationDetailView(viewModel: self.reservationDetailViewMaterial!.viewModel)
        }
    }
    
    func appendPath(viewType: ViewType, viewMaterial: ViewMaterial?) {
        switch viewType {
        case .homeResultView:
            self.homeResultViewMaterial = viewMaterial as? HomeResultViewMaterial
            homePath.append(.homeResultView)
        case .studioDetailView:
            self.studioDetailViewMaterial = viewMaterial as? StudioDetailViewMaterial
            switch tabNumber {
            case 0: homePath.append(.studioDetailView)
            case 1: reservationPath.append(.studioDetailView)
            default:
                break
            }
        case .productDetailView:
            self.productDetailViewMaterial = viewMaterial as? ProductDetailViewMaterial
            switch tabNumber {
            case 0: homePath.append(.productDetailView)
            case 1: reservationPath.append(.productDetailView)
            default: break
            }
        case .reservationConfirmView:
            self.reservationConfirmViewMaterial = viewMaterial as? ReservationConfirmViewMaterial
            switch tabNumber {
            case 0: homePath.append(.reservationConfirmView)
            case 1: reservationPath.append(.reservationConfirmView)
            default: break
            }
        case .reservationCompleteView:
            switch tabNumber {
            case 0: homePath.append(.reservationCompleteView)
            case 1: reservationPath.append(.reservationCompleteView)
            default: break
            }
        case .reservationDetailView:
            self.reservationDetailViewMaterial = viewMaterial as? ReservationDetailViewMaterial
            reservationPath.append(.reservationDetailView)
        }
    }
}
