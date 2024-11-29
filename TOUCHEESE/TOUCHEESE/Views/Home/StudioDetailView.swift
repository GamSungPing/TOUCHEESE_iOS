//
//  StudioDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI

struct StudioDetailView: View {
    @StateObject var viewModel: StudioDetailViewModel
    
    @Environment(\.isPresented) var isPresented
    @State private var selectedSegmentedControlIndex = 0
    
    var body: some View {
        let studio = viewModel.studio
        let studioDetail = viewModel.studioDetail
        
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 15) {
                ImageCarouselView(
                    imageURLs: studioDetail.detailImageURLs,
                    height: 250
                )
                
                // Studio 설명
                VStack(alignment: .leading, spacing: 6) {
                    Label(
                        "\(studio.formattedRating) (리뷰 \(studioDetail.reviewCount)개)",
                        systemImage: "star"
                    )
                    Label(
                        "\(studioDetail.businessHours)",
                        systemImage: "clock"
                    )
                    Label(
                        "\(studioDetail.address)",
                        systemImage: "mappin.and.ellipse"
                    )
                }
                .padding(.horizontal)
                
                CustomSegmentedControl(selectedIndex: $selectedSegmentedControlIndex)
                
                // 가격 또는 리뷰 View
                if selectedSegmentedControlIndex == 0 {
                    productListView
                } else {
                    reviewGridView
                }
            }
        }
        .toolbarRole(.editor)
        .toolbar(isPresented ? .hidden : .visible, for: .tabBar)
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
    
    private var productListView: some View {
        Text("상품 리스트 표시")
    }
    
    private var reviewGridView: some View {
        Text("리뷰 그리드 표시")
    }
}


fileprivate struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    let options = ["가격", "리뷰"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20)
                        .fill(.tcLightyellow)
                    
                    RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20)
                        .fill(.tcYellow)
                        .opacity(selectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
                .overlay {
                    Text(options[index])
                }
            }
        }
        .frame(height: 40)
    }
}


fileprivate struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        return Path(path.cgPath)
    }
}


#Preview {
    NavigationStack {
        StudioDetailView(
            viewModel: StudioDetailViewModel(studio: Studio.sample)
        )
    }
}
