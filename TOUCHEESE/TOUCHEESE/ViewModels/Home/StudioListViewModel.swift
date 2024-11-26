//
//  HomeResultViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/13/24.
//

import Foundation
import SwiftUI

final class StudioListViewModel: ObservableObject {
    
    // MARK: - Data
    private var selectedConcept: StudioConcept = .liveliness
    @Published private(set) var studios: [Studio] = []
    
    @Published var isFilteringByPrice: Bool = false
    @Published var isFilteringByRegion: Bool = false
    @Published private(set) var isFilteringByRating: Bool = false
    
    @Published private(set) var selectedPrice: StudioPrice = .all {
        didSet { isFilteringByPrice = selectedPrice != .all }
    }
    private var selectedAreas: Set<StudioRegion> = [.all] {
        didSet { isFilteringByRegion = selectedAreas != [.all] }
    }
    @Published private(set) var tempSelectedAreas: Set<StudioRegion> = []
    
    @Published private(set) var isStudioLoading: Bool = true
    
    private var page: Int = 1
    
    
    // MARK: - Intput
    func resetFilters() {
        isFilteringByPrice = false
        isFilteringByRegion = false
        isFilteringByRating = false
        
        selectedPrice = .all
        selectedAreas = [.all]
        Task { await fetchStudios() }
    }
    
    func applyAreaOptions() {
        selectedAreas = tempSelectedAreas
        Task { await fetchStudios() }
    }
    
    func resetTempAreaOptions() {
        tempSelectedAreas = [.all]
    }
    
    
    // MARK: - Output
    
    
    // MARK: - Logic
    func selectStudioConcept(_ concept: StudioConcept) {
        self.selectedConcept = concept
        Task {
            page = 1
            await fetchStudios()
        }
    }
    
    func selectStudioPriceFilter(_ price: StudioPrice) {
        self.selectedPrice = price
        Task { await fetchStudios() }
    }
    
    func toggleStudioRatingFilter() {
        self.isFilteringByRating.toggle()
        Task { await fetchStudios() }
    }
    
    func toggleAreaFilterOption(_ option: StudioRegion) {
        if option != .all {
            tempSelectedAreas.remove(.all)
            
            if tempSelectedAreas.contains(option) {
                tempSelectedAreas.remove(option)
            } else {
                tempSelectedAreas.insert(option)
            }
        } else {
            tempSelectedAreas = []
            tempSelectedAreas.insert(.all)
        }
    }
    
    func loadAreaOptions() {
        tempSelectedAreas = selectedAreas
    }
    
    func completeLoding() {
        isStudioLoading = true
    }
    
    @MainActor
    func loadMoreStudios() {
        if !isStudioLoading {
            page += 1
            
            let concept = selectedConcept
            let isHighRating = isFilteringByRating
            let regionArray = selectedAreas.map { $0 }
            let price = selectedPrice
            let page = page
            
            Task {
                do {
                    isStudioLoading = true
                    studios.append(contentsOf: try await NetworkManager.shared.getStudioDatas(
                        concept: concept,
                        isHighRating: isHighRating,
                        regionArray: regionArray,
                        price: price,
                        page: page
                    ))
                    
                    isStudioLoading = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    func fetchStudios() async {
        let concept = selectedConcept
        let isHighRating = isFilteringByRating
        var regionArray: [StudioRegion] {
            selectedAreas == [.all] ? [] : Array(selectedAreas)
        }
        let price = selectedPrice
        page = 1
        
        do {
            studios = try await NetworkManager.shared.getStudioDatas(
                concept: concept,
                isHighRating: isHighRating,
                regionArray: regionArray,
                price: price,
                page: page
            )
            
            isStudioLoading = false
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func resetStudios() {
        studios = []
    }
    
}
