//
//  ImageCarouselView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct ImageCarouselView: View {
    let imageURLs: [URL]
    @Binding var carouselIndex: Int
    @Binding var isShowingImageExtensionView: Bool
    
    var width: CGFloat = CGFloat.screenWidth
    var height: CGFloat = .infinity
    
    var body: some View {
        TabView(selection: $carouselIndex) {
            ForEach(imageURLs.indices, id:\.self) { index in
                KFImage(imageURLs[index])
                    .placeholder { ProgressView() }
                    .resizable()
                    .fade(duration: 0.25)
                    .scaledToFill()
                    .onTapGesture {
                        isShowingImageExtensionView.toggle()
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: width, height: height)
        .overlay(alignment: .bottomTrailing) {
            HStack {
                Spacer()
                Text("\(carouselIndex + 1) / \(imageURLs.count)")
                    .foregroundStyle(Color.white)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.black.opacity(0.5))
                    }
                    .padding()
            }
        }
    }
}

#Preview {
    ImageCarouselView(
        imageURLs: [
            URL(string: "https://i.imgur.com/Uw5nNHQ.png")!,
            URL(string: "https://i.imgur.com/Uw5nNHQ.png")!,
            URL(string: "https://i.imgur.com/Uw5nNHQ.png")!,
            URL(string: "https://i.imgur.com/Uw5nNHQ.png")!,
            URL(string: "https://i.imgur.com/Uw5nNHQ.png")!
        ],
        carouselIndex: .constant(0),
        isShowingImageExtensionView: .constant(false)
    )
}
