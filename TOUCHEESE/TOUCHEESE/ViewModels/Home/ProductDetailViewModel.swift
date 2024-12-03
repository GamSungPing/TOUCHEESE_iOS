//
//  ProductDetailViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/3/24.
//

import Foundation

final class ProductDetailViewModel: ObservableObject {
    // MARK: - Data
    let networkManager = NetworkManager.shared
    
    @Published private(set) var studio: Studio
    @Published private(set) var studioDetail: StudioDetail
    @Published private(set) var product: Product
    @Published private(set) var productDetail: ProductDetail = ProductDetail.sample1
        
    
    init(studio: Studio, studioDetails: StudioDetail, product: Product) {
        self.studio = studio
        self.studioDetail = studioDetails
        self.product = product
        
        Task {
            await fetchProductDetail()
        }
    }
    
    // MARK: - Input
    
    // MARK: - Output
    
    // MARK: - Logic
    @MainActor
    private func fetchProductDetail() async {
        do {
            productDetail = try await networkManager.getProductDetailData(productID: product.id)
        } catch {
            print("Fetch ProductDetail Error: \(error.localizedDescription)")
        }
    }
    
}


// 스튜디오 디테일 뷰에서 인스턴스 생성
// 프로덕트 디테일 뷰에서 스테이트 오브젝트 변수 + 환경변수 넘겨주기
