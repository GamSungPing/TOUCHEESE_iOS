//
//  FilterButtonView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/14/24.
//

import SwiftUI

struct FilterButtonView: View {
    let filter: StudioFilter
    var isFiltering: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            Text(filter.title)
            
            switch filter {
            case .area, .price:
                Image(systemName: "chevron.down")
            case .rating:
                EmptyView()
            }
        }
        .foregroundStyle(.black)
        .padding(.vertical, 5)
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(isFiltering ? .yellow : .gray)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            FilterButtonView(filter: .price, isFiltering: false)
            FilterButtonView(filter: .price, isFiltering: true)
        }
        
        HStack {
            FilterButtonView(filter: .area, isFiltering: false)
            FilterButtonView(filter: .area, isFiltering: true)
        }
        
        HStack {
            FilterButtonView(filter: .rating, isFiltering: false)
            FilterButtonView(filter: .rating, isFiltering: true)
        }
    }
}
