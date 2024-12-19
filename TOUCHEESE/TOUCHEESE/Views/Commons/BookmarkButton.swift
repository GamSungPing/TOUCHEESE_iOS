//
//  BookmarkButton.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/19/24.
//

import SwiftUI

struct BookmarkButton: View {
    @Binding var isBookmarked: Bool
    let size: CGFloat
    
    var body: some View {
        Button {
            isBookmarked.toggle()
        } label: {
            Image(isBookmarked ? .tcBookmarkFill : .tcBookmark)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BookmarkButton(isBookmarked: .constant(true), size: 30)
}
