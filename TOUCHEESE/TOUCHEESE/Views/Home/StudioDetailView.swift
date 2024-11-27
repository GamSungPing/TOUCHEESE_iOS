//
//  StudioDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI

struct StudioDetailView: View {
    @StateObject var viewModel: StudioDetailViewModel
    
    var body: some View {
        let studio = viewModel.studio
        
        VStack {
            Text("\(studio.name)")
        }
        .toolbarRole(.editor)
        .toolbar {
            leadingToolbarContent(for: studio)
            trailingToolbarContent
        }
    }
    
    private func leadingToolbarContent(
        for studio: Studio
    ) -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            HStack {
                ProfileImageView(
                    imageURL: studio.profileImageURL,
                    size: 40
                )
                
                Text("\(studio.name)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var trailingToolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "bookmark")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StudioDetailView(
            viewModel: StudioDetailViewModel(studio: Studio.sample)
        )
    }
}
