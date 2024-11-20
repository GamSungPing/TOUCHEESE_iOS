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
    @Published var studios: [Studio] = []
    
    @Published var isFilteringByPrice: Bool = false
    @Published var isFilteringByRegion: Bool = false
    @Published var isFilteringByRating: Bool = false
    
    @Published private(set) var selectedPrice: StudioPrice = .all {
        didSet { isFilteringByPrice = selectedPrice != .all }
    }
    private var selectedAreas: Set<StudioRegion> = [] {
        didSet { isFilteringByRegion = !selectedAreas.isEmpty }
    }
    @Published private(set) var tempSelectedAreas: Set<StudioRegion> = []
    
    
    // MARK: - Intput
    func resetFilters() {
        isFilteringByPrice = false
        isFilteringByRegion = false
        isFilteringByRating = false
        
        selectedPrice = .all
        selectedAreas = []
        Task { await fetchStudios() }
    }
    
    func applyAreaOptions() {
        selectedAreas = tempSelectedAreas
        Task { await fetchStudios() }
    }
    
    func resetTempAreaOptions() {
        tempSelectedAreas = []
    }
    
    
    // MARK: - Output
    
    
    // MARK: - Logic
    func selectStudioConcept(_ concept: StudioConcept) {
        self.selectedConcept = concept
        Task { await fetchStudios() }
    }
    
    func selectStudioPriceFilter(_ price: StudioPrice) {
        self.selectedPrice = price
        Task { await fetchStudios() }
    }
    
    func toggleAreaOption(_ option: StudioRegion) {
        if tempSelectedAreas.contains(option) {
            tempSelectedAreas.remove(option)
        } else {
            tempSelectedAreas.insert(option)
        }
    }
    
    func loadAreaOptions() {
        tempSelectedAreas = selectedAreas
    }
    
    @MainActor
    func fetchStudios() async {
        let concept = selectedConcept
        let isHighRating = isFilteringByRating
        let regionArray = selectedAreas.map { $0 }
        let price = selectedPrice
        
        do {
            studios = try await NetworkManager.shared.getStudioDatas(
                concept: concept,
                isHighRating: isHighRating,
                regionArray: regionArray,
                price: price
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
