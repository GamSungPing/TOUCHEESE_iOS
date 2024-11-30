//
//  ImageGridView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/30/24.
//

import SwiftUI
import Kingfisher

struct ReviewImageGridView: View {
    let reviews: [Review]?
    let action: (Review) -> Void
    
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
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: gridSize)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            action(review)
                        }
                        .background {
                            KFImage(review.imageURL)
                                .placeholder { ProgressView() }
                                .downsampling(size: CGSize(width: 200, height: 200))
                                .cacheMemoryOnly()
                                .fade(duration: 0.25)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: gridSize)
                                .clipped()
                        }
                }
            }
        } else {
            VStack(alignment: .center) {
                Image(systemName: "tray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .foregroundStyle(Color.gray)
                
                Text("해당 스튜디오의 리뷰가 없습니다.")
                    .foregroundStyle(Color.gray)
                    .padding(.top, 20)
            }
            .frame(width: CGFloat.screenWidth)
            .padding()
        }
        
    }
}

#Preview {
    ReviewImageGridView(reviews: Review.samples) { review in
        print(review.id)
    }
}
