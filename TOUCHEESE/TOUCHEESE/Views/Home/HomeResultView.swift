//
//  HomeResultView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct HomeResultView: View {
    @EnvironmentObject private var studioListViewModel: StudioListViewModel
    
    let concept: StudioConcept
    
    @State private var isShowingPriceFilterOptionView: Bool = false
    @State private var isShowingAreaFilterOptionView: Bool = false
    
    var body: some View {
        VStack {
            filtersView
                .padding(.horizontal)
            
            ZStack(alignment: .top) {
                if studioListViewModel.studios.isEmpty {
                    studioEmptyView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(studioListViewModel.studios) { studio in
                                StudioRow(studio: studio)
                            }
                        }
                    }
                    .scrollIndicators(.never)
                    .padding(.vertical, 5)
                }
                
                if isShowingPriceFilterOptionView {
                    filterOptionView(.price)
                }
                
                if isShowingAreaFilterOptionView {
                    filterOptionView(.area)
                }
            }
        }
        .navigationTitle("\(concept.title)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .onAppear {
            studioListViewModel.selectStudioConcept(concept)
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
                toggleFilter(&isShowingAreaFilterOptionView)
            } label: {
                FilterButtonView(
                    filter: .area,
                    isFiltering: studioListViewModel.isFilteringByRegion
                )
            }
            
            Button {
                studioListViewModel.toggleStudioRatingFilter()
                
                isShowingPriceFilterOptionView = false
                isShowingAreaFilterOptionView = false
            } label: {
                FilterButtonView(
                    filter: .rating,
                    isFiltering: studioListViewModel.isFilteringByRating
                )
            }
            
            Spacer()
            
            Button {
                isShowingAreaFilterOptionView = false
                isShowingPriceFilterOptionView = false
                
                studioListViewModel.resetFilters()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(Color.black)
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
            LazyVGrid(columns: columns) {
                ForEach(filter.options, id: \.id) { option in
                    if let area = option as? StudioRegion {
                        filterButton(
                            for: area,
                            isSelected: studioListViewModel.tempSelectedAreas.contains(area)
                        )
                    } else if let price = option as? StudioPrice {
                        filterButton(
                            for: price,
                            isSelected: price == studioListViewModel.selectedPrice
                        )
                    }
                }
            }
            
            if filter == .area {
                HStack(spacing: 100) {
                    Button {
                        studioListViewModel.resetTempAreaOptions()
                    } label: {
                        Text("초기화")
                            .foregroundStyle(Color.black)
                    }
                    
                    Button {
                        studioListViewModel.applyAreaOptions()
                        isShowingAreaFilterOptionView = false
                    } label: {
                        Text("적용하기")
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .padding(.horizontal)
                .foregroundStyle(Color.yellow)
                .shadow(radius: 5, x: 2, y: 5)
        }
        .onAppear {
            studioListViewModel.loadAreaOptions()
        }
        .onDisappear {
            studioListViewModel.resetTempAreaOptions()
        }
    }
    
    private func filterButton<T: OptionType>(for option: T, isSelected: Bool) -> some View {
        Button {
            if let area = option as? StudioRegion {
                studioListViewModel.toggleAreaOption(area)
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
                            .foregroundStyle(isSelected ? Color.red : Color.clear)
                    )
            }
            .frame(width: 80)
        }
    }
    
    private func toggleFilter(_ filter: inout Bool) {
        if !filter {
            isShowingPriceFilterOptionView = false
            isShowingAreaFilterOptionView = false
        }
        
        filter.toggle()
    }
}

#Preview {
    NavigationStack {
        HomeResultView(concept: .liveliness)
    }
    .environmentObject(StudioListViewModel())
}
