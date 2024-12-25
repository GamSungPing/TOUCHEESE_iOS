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
    let action: () -> Void
    
    var body: some View {
        Button {
            // isBookmarked.toggle()
            action()
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
    BookmarkButton(
        isBookmarked: .constant(true),
        size: 30) {
            print("찜 버튼 눌림")
        }
}
