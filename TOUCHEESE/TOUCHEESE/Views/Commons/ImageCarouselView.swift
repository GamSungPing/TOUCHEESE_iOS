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
    let width: CGFloat
    let height: CGFloat
    
    @State private var currentIndex: Int = 0
    
    init(
        imageURLs: [URL],
        width: CGFloat = UIScreen.main.bounds.width,
        height: CGFloat = .infinity
    ) {
        self.imageURLs = imageURLs
        self.width = width
        self.height = height
    }
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(imageURLs.indices, id:\.self) { index in
                KFImage(imageURLs[index])
                    .placeholder { _ in
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: width, height: height)
        .overlay(alignment: .bottomTrailing) {
            HStack {
                Spacer()
                Text("\(currentIndex + 1) / \(imageURLs.count)")
                    .foregroundStyle(Color.white)
                    .font(.caption)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.gray)
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
        height: 300
    )
}
