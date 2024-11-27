//
//  ProfileImageView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    let imageURL: URL
    let size: CGFloat
    
    var body: some View {
        KFImage(imageURL)
            .placeholder { _ in
                ProgressView()
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundStyle(Color.black)
            .clipShape(.circle)
            .overlay {
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
            }
    }
}

#Preview {
    ProfileImageView(
        imageURL: URL(string: "https://i.imgur.com/aXwN6fF.jpeg")!,
        size: 40
    )
}
