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
    @Published var conceptStudios: [Studio] = []
    
    @Published var isFilteringByPrice: Bool = false
    @Published var isFilteringByArea: Bool = false
    @Published var isFilteringByRating: Bool = false
    
    @Published var selectedPrice: StudioPrice = .all {
        didSet { isFilteringByPrice = selectedPrice != .all }
    }
    private var selectedAreas: Set<StudioRegion> = [] {
        didSet { isFilteringByArea = !selectedAreas.isEmpty }
    }
    @Published var tempSelectedAreas: Set<StudioRegion> = []
    
    
    // MARK: - Intput
    func resetFilters() {
        isFilteringByPrice = false
        isFilteringByArea = false
        isFilteringByRating = false
        
        selectedPrice = .all
        selectedAreas = []
    }
    
    func applyAreaOptions() {
        selectedAreas = tempSelectedAreas
    }
    
    func resetTempAreaOptions() {
        tempSelectedAreas = []
    }
    
    
    // MARK: - Output
    @MainActor
    func fetchFilteredStudiosBy(concept: StudioConcept) async {
        self.conceptStudios = await getFilterStudiosBy(concept: concept)
    }
    
    
    // MARK: - Logic
    func selectStudioConcept(_ concept: StudioConcept) {
        self.selectedConcept = concept
        Task { await fetchFilteredStudiosBy(concept: concept) }
    }
    
    /// 서버로부터 concept으로 필터된 스튜디오 목록을 받는다.
    private func getFilterStudiosBy(concept: StudioConcept) async -> [Studio] {
        do {
            let filteredStudios = try await NetworkManager.shared.requestConceptStudio(concept: concept)
            return filteredStudios
        } catch {
            print(error.localizedDescription)
            return []
        }
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
    
}
