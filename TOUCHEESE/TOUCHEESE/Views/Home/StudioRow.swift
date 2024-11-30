//
//  StudioRow.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/14/24.
//

import SwiftUI
import Kingfisher

struct StudioRow: View {
    let studio: Studio
    private var portfolioImageURLs: [URL] {
        studio.portfolioImageURLs
    }
    
    @State private var isBookmarked = false
    
    var body: some View {
        VStack {
            HStack {
                ProfileImageView(
                    imageURL: studio.profileImageURL,
                    size: 45
                )
                
                VStack(alignment: .leading) {
                    Text("\(studio.name)")
                        .foregroundStyle(Color.black)
                    
                    Label {
                        Text("\(studio.formattedRating)")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                
                Spacer()
                
                bookmarkButton
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            portfolioImagesScrollView(portfolioImageURLs)
        }
    }
    
    private var bookmarkButton: some View {
        Button {
            isBookmarked.toggle()
        } label: {
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.yellow)
        }
    }
    
    @ViewBuilder
    private func portfolioImagesScrollView(_ imageURLs: [URL]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(imageURLs.indices, id: \.self) { index in
                    KFImage(imageURLs[index])
                        .placeholder { _ in
                            ProgressView()
                        }
                        .resizable()
                        .downsampling(size: CGSize(width: 230, height: 230))
                        .cancelOnDisappear(true)
                        .fade(duration: 0.25)
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(Color.black)
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    StudioRow(studio: Studio.sample)
}
