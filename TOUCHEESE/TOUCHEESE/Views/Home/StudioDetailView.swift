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
        
        Text("\(studio.name)")
    }
}

#Preview {
    NavigationStack {
        StudioDetailView(
            viewModel: StudioDetailViewModel(studio: Studio.sample)
        )
    }
}
