//
//  StudioDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct StudioDetailView: View {
    @EnvironmentObject private var tabbarManager: TabbarManager
    @StateObject var viewModel: StudioDetailViewModel
    
    @Environment(\.isPresented) var isPresented
    
    @State private var selectedSegmentedControlIndex = 0
    @State private var carouselIndex = 0
    @State private var isShowingImageExtensionView = false
    @State private var isExpanded = false
    
    @State private var isPushingReviewDetailView = false
    
    var body: some View {
        let studio = viewModel.studio
        let studioDetail = viewModel.studioDetail
        
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 15) {
                ImageCarouselView(
                    imageURLs: studioDetail.detailImageURLs,
                    carouselIndex: $carouselIndex,
                    isShowingImageExtensionView: $isShowingImageExtensionView,
                    height: 280
                )
                
                // Studio 설명 View
                VStack(alignment: .leading, spacing: 6) {
                    Text(studio.name)
                        .foregroundStyle(.tcGray10)
                        .font(.pretendardSemiBold18)
                        .padding(.bottom, 4)
                    
                    HStack(spacing: 4) {
                        Image(.tcStarFill)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        
                        Text(studio.formattedRating)
                            .foregroundStyle(.tcGray10)
                            .font(.pretendardSemiBold16)
                        
                        Text("(\(studio.reviewCount))")
                            .foregroundStyle(.tcGray10)
                            .font(.pretendardRegular16)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.tcGray01)
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.tcGray02, lineWidth: 1)
                            }
                    )
                    
                    HStack(spacing: 4) {
                        Image(.tcClock)
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text(viewModel.businessHourString)
                            .foregroundStyle(.tcGray08)
                            .font(.pretendardRegular16)
                    }
                    
                    HStack(spacing: 4) {
                        Image(.tcMapPinFill)
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text(studioDetail.address)
                            .foregroundStyle(.tcGray08)
                            .font(.pretendardRegular16)
                    }
                    
                }
                .padding(.horizontal, 16)
                
                // Studio 공지 View
                if let notice = studioDetail.notice, notice != "" {
                    NoticeView(notice: notice, isExpanded: $isExpanded)
                        .padding(.top, 3)
                        .padding(.bottom, 2)
                        .padding(.horizontal)
                }
                
                CustomSegmentedControl(selectedIndex: $selectedSegmentedControlIndex)
                
                // 상품 또는 리뷰 View
                if selectedSegmentedControlIndex == 0 {
                    ProductListView(studioDetail: studioDetail, studio: studio)
                        .environmentObject(viewModel)
                } else {
                    ReviewImageGridView(
                        reviews: studioDetail.reviews.content,
                        isPushingDetailView: $isPushingReviewDetailView
                    )
                    .padding(.top, -13)
                    .environmentObject(viewModel)
                }
            }
        }
        .toolbarRole(.editor)
        .toolbar(tabbarManager.isHidden ? .hidden : .visible, for: .tabBar)
        .toolbar {
            leadingToolbarContent(for: studio)
            trailingToolbarContent
        }
        .animation(.easeInOut, value: isExpanded)
        .fullScreenCover(isPresented: $isShowingImageExtensionView) {
            ImageExtensionView(
                imageURLs: studioDetail.detailImageURLs,
                currentIndex: $carouselIndex,
                isShowingImageExtensionView: $isShowingImageExtensionView
            )
        }
        .navigationDestination(isPresented: $isPushingReviewDetailView) {
            ReviewDetailView()
                .environmentObject(viewModel)
        }
        .onAppear {
            tabbarManager.isHidden = true
        }
    }
    
    private func leadingToolbarContent(
        for studio: Studio
    ) -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            HStack {
                ProfileImageView(
                    imageURL: studio.profileImageURL,
                    size: 35
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
}


fileprivate struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    let options = ["상품", "리뷰"]
    
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
    @EnvironmentObject private var navigationManager: NavigationManager
    let studioDetail: StudioDetail
    let studio: Studio
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("촬영 상품")
                .padding(.init(top: 15, leading: 0, bottom: -10, trailing: 0))
            
            ForEach(studioDetail.products, id: \.self) { product in
                Button {
                    navigationManager.appendPath(viewType: .productDetailView, viewMaterial: ProductDetailViewMaterial(viewModel: ProductDetailViewModel(studio: studio, studioDetails: studioDetail, product: product)))
                } label: {
                    HStack(spacing: 15) {
                        KFImage(product.imageURL)
                            .placeholder { ProgressView() }
                            .resizable()
                            .downsampling(size: CGSize(width: 250, height: 250))
                            .fade(duration: 0.25)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 150)
                            .clipped()
                            .overlay {
                                Rectangle()
                                    .fill(Color.clear)
                                    .border(Color.black, width: 1)
                            }
                        
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .fontWeight(.semibold)
                                .padding(.bottom, 1)
                            
                            Text(product.description)
                                .font(.system(size: 14))
                                .lineLimit(4)
                                .multilineTextAlignment(.leading)
                                .frame(alignment: .leading)
                            Text("리뷰 \(product.reviewCount)개")
                                .font(Font.caption)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Text("\(product.price)원")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                    }
                }
            }
            
            Color.clear
                .frame(height: 30)
        }
        .padding(.horizontal)
    }
}


fileprivate struct NoticeView: View {
    let notice: String?
    @Binding var isExpanded: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Image(.tcSpeaker)
                .resizable()
                .frame(width: 24, height: 24)
            
            if let notice {
                Text("\(notice)")
                    .font(.pretendardRegular14)
                    .foregroundStyle(.tcGray07)
                    .padding(.top, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(isExpanded ? nil : 1)
                    .multilineTextAlignment(.leading)
                
                if notice.count > 26 {
                    Button {
                        isExpanded.toggle()
                    } label: {
                        Image(isExpanded ? .tcTriangleUp : .tcTriangleDown)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.tcGray01)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.tcGray02, lineWidth: 1)
                }
        }
    }
}


#Preview {
    NavigationStack {
        StudioDetailView(
            viewModel: StudioDetailViewModel(studio: Studio.sample)
        )
        .environmentObject(TabbarManager())
        .environmentObject(NavigationManager())
    }
}
