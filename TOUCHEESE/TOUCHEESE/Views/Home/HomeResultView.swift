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
    
    @Environment(\.dismiss) private var dismiss
    
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
                        Color.clear
                            .frame(height: 12)
                        
                        LazyVStack(spacing: 20) {
                            ForEach(studioListViewModel.studios) { studio in
                                Button {
                                    navigationManager.appendPath(viewType: .studioDetailView, viewMaterial: StudioDetailViewMaterial(viewModel: StudioDetailViewModel(studio: studio)))
                                } label: {
                                    StudioRow(studio: studio)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Color.clear
                                .onAppear {
                                    studioListViewModel.loadMoreStudios()
                                }
                        }
                        .navigationDestination(for: Studio.self) { studio in
                            StudioDetailView(
                                viewModel: StudioDetailViewModel(studio: studio)
                            )
                        }
                    }
                    .scrollIndicators(.never)
                }
            }
        }
        .customNavigationBar(centerView: {
            Text("\(concept.title)")
                .modifier(NavigationTitleModifier())
        }, leftView: {
            Button {
                dismiss()
            } label: {
                NavigationBackButtonView()
            }
        })
        .sheet(isPresented: $isShowingPriceFilterOptionView) {
            filterOptionView(.price)
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingRegionFilterOptionView) {
            filterOptionView(.region)
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            studioListViewModel.selectStudioConcept(concept)
            studioListViewModel.completeLoding()
            
            tabbarManager.isHidden = false
        }
        .background(.tcGray01)
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
        HStack(spacing: 6) {
            Button {
                toggleFilter(&isShowingPriceFilterOptionView)
            } label: {
                FilterButtonView(
                    filter: .price,
                    isFiltering: studioListViewModel.isFilteringByPrice
                )
            }
            .buttonStyle(.plain)
            
            Button {
                toggleFilter(&isShowingRegionFilterOptionView)
            } label: {
                FilterButtonView(
                    filter: .region,
                    isFiltering: studioListViewModel.isFilteringByRegion
                )
            }
            .buttonStyle(.plain)
            
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
            .buttonStyle(.plain)
            
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
                        .frame(height: 15)
                        .foregroundStyle(Color.black)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private func filterOptionView(_ filter: StudioFilter) -> some View {
        VStack(spacing: 16) {
            LeadingTextView(
                text: "\(filter.title)",
                font: .pretendardSemiBold(20)
            )
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(filter.options, id: \.id) { option in
                        if let region = option as? StudioRegion {
                            filterOptionButton(
                                for: region,
                                isSelected: studioListViewModel.tempSelectedRegions.contains(region)
                            )
                        } else if let price = option as? StudioPrice {
                            filterOptionButton(
                                for: price,
                                isSelected: price == studioListViewModel.tempSelectedPrice
                            )
                        }
                    }
                }
            }
            
            FillBottomButton(isSelectable: true, title: "적용하기") {
                switch filter {
                case .region:
                    studioListViewModel.applyRegionOptions()
                    isShowingRegionFilterOptionView = false
                case .price:
                    studioListViewModel.applyPriceOptions()
                    isShowingPriceFilterOptionView = false
                case .rating: break
                }
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
        .onAppear {
            studioListViewModel.loadRegionOptions()
            studioListViewModel.loadPriceOptions()
        }
    }
    
    private func filterOptionButton<T: OptionType>(
        for option: T,
        isSelected: Bool
    ) -> some View {
        Button {
            if let region = option as? StudioRegion {
                studioListViewModel.toggleRegionFilterOption(region)
            } else if let price = option as? StudioPrice {
                studioListViewModel.selectStudioPriceFilter(price)
            }
        } label: {
            HStack {
                Text("\(option.title)")
                    .foregroundStyle(.tcGray10)
                    .font(isSelected ? .pretendardBold(16) : .pretendardRegular16)
                
                Spacer()
                
                if isSelected {
                    Image(.tcCheckmark)
                        .resizable()
                        .frame(width: 28, height: 28)
                        .scaledToFit()
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .tcPrimary01 : .clear)
            )
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
