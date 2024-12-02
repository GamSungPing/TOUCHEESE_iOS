//
//  StudioDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import Foundation

final class StudioDetailViewModel: ObservableObject {
    
    @Published private(set) var studio: Studio
    @Published private(set) var studioDetail: StudioDetail = StudioDetail.sample
    
    let networkManager = NetworkManager.shared
    
    init(studio: Studio) {
        self.studio = studio
        
        Task {
            await fetchStudioDetail(StudioID: studio.id)
        }
    }
    
    @MainActor
    func fetchStudioDetail(StudioID id: Int) async {
        do {
            studioDetail = try await networkManager.getStudioDetailData(studioID: id)
        } catch {
            print("Fetch StudioDetail Error: \(error.localizedDescription)")
        }
    }
    
    // Test 코드, 불필요시 지우기
    func fetchReviewDetail(reviewID: Int) async {
        do {
            dump(try await networkManager.getReviewDetailData(studioID: studio.id, reviewID: reviewID))
        } catch {
            print("Fetch ReviewDetail Error: \(error.localizedDescription)")
        }
    }
    
    // Test 코드, 불필요시 지우기
    func fetchProductDetail(productID: Int) async {
        do {
            dump(try await networkManager.getProductDetailData(productID: productID))
        } catch {
            print("Fetch ProductDetail Error: \(error.localizedDescription)")
        }
    }
    
}
