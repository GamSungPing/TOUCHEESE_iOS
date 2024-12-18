//
//  ImageGridView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/30/24.
//

import SwiftUI
import Kingfisher

struct ReviewImageGridView: View {
    @EnvironmentObject var viewModel: StudioDetailViewModel
    
    let reviews: [Review]?
    @Binding var isPushingDetailView: Bool
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 2),
        count: 3
    )
    
    private var gridSize: CGFloat {
        (CGFloat.screenWidth - 4) / 3
    }
    
    var body: some View {
        if let reviews {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(reviews) { review in
                    KFImage(review.imageURL)
                        .placeholder { ProgressView() }
                        .downsampling(size: CGSize(width: 200, height: 200))
                        .cacheMemoryOnly()
                        .cancelOnDisappear(true)
                        .fade(duration: 0.25)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: gridSize)
                        .clipped()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isPushingDetailView.toggle()
                            
                            Task {
                                await viewModel.fetchReviewDetail(reviewID: review.id)
                            }
                        }
                }
            }
        } else {
            CustomEmptyView(viewType: .review)
        }
        
    }
}

#Preview {
    ReviewImageGridView(reviews: Review.samples, isPushingDetailView: .constant(false))
}
