//
//  HomeResultView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct HomeResultView: View {
    @EnvironmentObject private var tabbarManager: TabbarManager
    @EnvironmentObject private var studioListViewModel: StudioListViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var tempNavigationManager: TempNavigationManager
    
    let concept: StudioConcept
    
    @State private var isShowingPriceFilterOptionView: Bool = false
    @State private var isShowingRegionFilterOptionView: Bool = false
    
    var body: some View {
        VStack {
            filtersView
                .padding(.horizontal)
                .padding(.bottom, -5)
            
            ZStack(alignment: .top) {
                if studioListViewModel.studios.isEmpty && studioListViewModel.isStudioLoading == false {
                    studioEmptyView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(studioListViewModel.studios) { studio in
                                Button {
                                    navigationManager.appendPath(viewType: .studioDetailView, viewMaterial: StudioDetailViewMaterial(viewModel: StudioDetailViewModel(studio: studio)))
                                } label: {
                                    StudioRow(studio: studio)
                                }
                            }
                            
                            Color.clear
                                .onAppear {
                                    studioListViewModel.loadMoreStudios()
                                }
                        }
                    }
                    .scrollIndicators(.never)
                }
                
                if isShowingPriceFilterOptionView {
                    filterOptionView(.price)
                }
                
                if isShowingRegionFilterOptionView {
                    filterOptionView(.region)
                }
            }
        }
        .navigationTitle("\(concept.title)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .onAppear {
            studioListViewModel.selectStudioConcept(concept)
            studioListViewModel.completeLoding()
            
            tabbarManager.isHidden = false
        }
    }
    
    private var studioEmptyView: some View {
        VStack {
            Spacer()
            
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundStyle(Color.gray)
            
            Text("해당하는 스튜디오가 없습니다.")
                .foregroundStyle(Color.gray)
                .padding(.top, 30)
            
            Button {
                studioListViewModel.resetFilters()
            } label: {
                Text("필터 초기화 하기")
                    .foregroundStyle(Color.black)
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .padding()
    }
    
    private var filtersView: some View {
        HStack {
            Button {
                toggleFilter(&isShowingPriceFilterOptionView)
            } label: {
                FilterButtonView(
                    filter: .price,
                    isFiltering: studioListViewModel.isFilteringByPrice
                )
            }
            
            Button {
                toggleFilter(&isShowingRegionFilterOptionView)
            } label: {
                FilterButtonView(
                    filter: .region,
                    isFiltering: studioListViewModel.isFilteringByRegion
                )
            }
            
            Button {
                studioListViewModel.toggleStudioRatingFilter()
                
                isShowingPriceFilterOptionView = false
                isShowingRegionFilterOptionView = false
            } label: {
                FilterButtonView(
                    filter: .rating,
                    isFiltering: studioListViewModel.isFilteringByRating
                )
            }
            
            Spacer()
            
            if studioListViewModel.isShowingResetButton {
                Button {
                    isShowingRegionFilterOptionView = false
                    isShowingPriceFilterOptionView = false
                    
                    studioListViewModel.resetFilters()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundStyle(Color.black)
                }
            }
        }
    }
    
    @ViewBuilder
    private func filterOptionView(_ filter: StudioFilter) -> some View {
        let columns = Array(
            repeating: GridItem(.flexible()),
            count: 4
        )
        
        VStack {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(filter.options, id: \.id) { option in
                    if let region = option as? StudioRegion {
                        filterButton(
                            for: region,
                            isSelected: studioListViewModel.tempSelectedRegions.contains(region)
                        )
                    } else if let price = option as? StudioPrice {
                        filterButton(
                            for: price,
                            isSelected: price == studioListViewModel.selectedPrice
                        )
                    }
                }
            }
            
            if filter == .region {
                Button {
                    studioListViewModel.applyRegionOptions()
                    isShowingRegionFilterOptionView = false
                } label: {
                    Text("적용하기")
                        .foregroundStyle(Color.black)
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .padding(.horizontal)
                .foregroundStyle(Color.tcLightyellow)
                .shadow(radius: 5, x: 2, y: 5)
        }
        .onAppear {
            studioListViewModel.loadRegionOptions()
        }
    }
    
    private func filterButton<T: OptionType>(for option: T, isSelected: Bool) -> some View {
        Button {
            if let region = option as? StudioRegion {
                studioListViewModel.toggleRegionFilterOption(region)
            } else if let price = option as? StudioPrice {
                studioListViewModel.selectStudioPriceFilter(price)
                isShowingPriceFilterOptionView = false
            }
        } label: {
            VStack {
                Text("\(option.title)")
                    .frame(maxHeight: 50)
                    .foregroundStyle(Color.black)
                
                Circle()
                    .frame(width: 25)
                    .foregroundStyle(Color.white)
                    .overlay(
                        Circle()
                            .frame(width: 15)
                            .foregroundStyle(isSelected ? Color.tcYellow : Color.clear)
                    )
            }
            .frame(width: 80)
        }
    }
    
    private func toggleFilter(_ filter: inout Bool) {
        if !filter {
            isShowingPriceFilterOptionView = false
            isShowingRegionFilterOptionView = false
        }
        
        filter.toggle()
    }
}

#Preview {
    NavigationStack {
        HomeResultView(concept: .liveliness)
    }
    .environmentObject(StudioListViewModel())
    .environmentObject(TabbarManager())
    .environmentObject(NavigationManager())
}
