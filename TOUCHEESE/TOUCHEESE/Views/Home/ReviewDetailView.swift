//
//  ReviewDetailView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/2/24.
//

import SwiftUI

struct ReviewDetailView: View {
    @EnvironmentObject private var tabbarManager: TabbarManager
    @EnvironmentObject var viewModel: StudioDetailViewModel
    
    @State var carouselIndex: Int = 0
    @State var isShowingImageExtensionView: Bool = false
    
    var body: some View {
        let studio = viewModel.studio
        let reviewDetail = viewModel.reviewDetail
        let reply = reviewDetail.reply
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // 스튜디오 이미지 캐러셸 뷰
                ImageCarouselView(
                    imageURLs: reviewDetail.imageURLs,
                    carouselIndex: $carouselIndex,
                    isShowingImageExtensionView: $isShowingImageExtensionView,
                    height: 340
                )
                .padding(.bottom, 15)
                
                // 사용자가 작성한 리뷰 뷰
                reviewContentView(reviewDetail: reviewDetail)
                
                DividerView(horizontalPadding: 10)
                    .padding(.bottom)
                
                // 사용자가 작성한 리뷰에 대한 스튜디오의 댓글 뷰
                reviewReplyView(reply: reply, studio: studio)
                
                Spacer()
            }
        }
        .toolbarRole(.editor)
        .toolbar {
            leadingToolbarContent(for: reviewDetail)
        }
        .toolbar(tabbarManager.isHidden ? .hidden : .visible, for: .tabBar)
        .fullScreenCover(isPresented: $isShowingImageExtensionView) {
            ImageExtensionView(
                imageURLs: reviewDetail.imageURLs,
                currentIndex: $carouselIndex,
                isShowingImageExtensionView: $isShowingImageExtensionView
            )
        }
        .onAppear {
            tabbarManager.isHidden = true
        }
    }
    
    private func reviewContentView(reviewDetail: ReviewDetail) -> some View {
        VStack(alignment: .leading) {
            Text("\(reviewDetail.content ?? "")")
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            
            HStack {
                Label {
                    Text(String(format: "%.1f", reviewDetail.rating))
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                
                Text("\(reviewDetail.dateString.iso8601ToDate?.toString(format: .yearMonthDay) ?? "")")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                    .padding(.leading, 5)
                
                Spacer()
            }
        }
        .padding(.leading)
    }
    
    private func reviewReplyView(
        reply: Reply?,
        studio: Studio
    ) -> some View {
        VStack {
            if let reply {
                HStack(alignment: .top) {
                    ProfileImageView(
                        imageURL: studio.profileImageURL,
                        size: 40
                    )
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(reply.studioName)")
                                .fontWeight(.bold)
                            
                            Text("\(reply.dateString.iso8601ToDate?.toString(format: .yearMonthDay) ?? "알 수 없음")")
                                .foregroundStyle(.gray)
                                .font(.footnote)
                            
                            Spacer()
                            
                        }
                        .padding(.top, 4)
                        
                        Text("\(reply.content)")
                            .font(.caption)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.leading)
            }
        }
    }
    
    private func leadingToolbarContent(
        for reviewDetail: ReviewDetail
    ) -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            HStack {
                ProfileImageView(
                    imageURL: reviewDetail.userProfileImageURL,
                    size: 35
                )
                
                Text("\(reviewDetail.userName)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReviewDetailView()
            .environmentObject(
                StudioDetailViewModel(studio: Studio.sample)
            )
            .environmentObject(TabbarManager())
    }
}
