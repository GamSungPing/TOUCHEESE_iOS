//
//  StudioDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

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
                    ProductListView(studioDetail: studioDetail)
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
                    RoundedCornersShape(
                        corners: [.topLeft, .topRight],
                        radius: 20
                    )
                    .fill(.tcLightyellow)
                    
                    RoundedCornersShape(
                        corners: [.topLeft, .topRight],
                        radius: 20
                    )
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


fileprivate struct ProductListView: View {
    let studioDetail: StudioDetail
    @State private var isExpanded = false
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 15) {
            if let notice = studioDetail.notice {
                NoticeView(notice: notice, isExpanded: $isExpanded)
            }
            
            Text("촬영 상품")
                .padding(.init(top: 15, leading: 0, bottom: -10, trailing: 0))
            
            ForEach(studioDetail.products, id: \.self) { product in
                HStack(spacing: 15) {
                    KFImage(product.imageURL)
                        .placeholder { _ in
                            ProgressView()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                        .overlay {
                            Rectangle()
                                .fill(Color.clear)
                                .border(Color.black, width: 1)
                        }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(product.name)
                            .fontWeight(.semibold)
                        
                        Text(product.description)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                        
                        Text("리뷰 \(product.reviewCount)개")
                            .font(Font.caption)
                            .foregroundStyle(Color.gray)
                        
                        HStack {
                            Spacer()
                            
                            Text("\(product.price)원")
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                }
                .onTapGesture {
                    print("\(product.name)")
                }
            }
            
            Color.clear
                .frame(height: 30)
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: isExpanded)
        .onAppear {
            
            print(studioDetail.products.count)
        }
    }
}


fileprivate struct NoticeView: View {
    let notice: String?
    @Binding var isExpanded: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "megaphone.fill")
            
            if let notice {
                Text("\(notice)")
                    .frame(maxWidth: .infinity)
                    .lineLimit(isExpanded ? nil : 2)
                    .multilineTextAlignment(.leading)
            }
            
            Button {
                isExpanded.toggle()
            } label: {
                Image(systemName: isExpanded ? "arrowtriangle.up" : "arrowtriangle.down")
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.tcLightgray)
        }
        .padding(.top, -5)
    }
}


#Preview {
    NavigationStack {
        StudioDetailView(
            viewModel: StudioDetailViewModel(studio: Studio.sample)
        )
    }
}
