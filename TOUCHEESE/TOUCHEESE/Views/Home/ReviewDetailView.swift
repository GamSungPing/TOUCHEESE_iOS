//
//  ReviewDetailView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/2/24.
//

import SwiftUI

struct ReviewDetailView: View {
    // MARK: - Temp Datas
    let studio = Studio.sample
    let review = Review.sample
    let reviewDetail = ReviewDetail.sample
    let reply = Reply.sample
    let studioProfileImageString = URL(string: Studio.sample.profileImageString)!
    
    let tempUserName = "김민성"
    
    let day = Reply.sample.dateString.iso8601ToDate?.pastDayString
    
    @State var carouselIndex: Int = 0
    @State var isShowingImageExtensionView: Bool = false
    
    var body: some View {
        ScrollView(Axis.Set.vertical, showsIndicators: false) {
            VStack {
                DividerView(horizontalPadding: 0, color: .tcLightyellow)
                
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
                reviewReplyView(reply: reply, studioProfileImageString: studioProfileImageString)
                
                Spacer()
            }
        }
        .toolbarRole(.editor)
        .toolbar {
            leadingToolbarContent(for: studio)
        }
        .fullScreenCover(isPresented: $isShowingImageExtensionView) {
            ImageExtensionView(
                imageURLs: reviewDetail.imageURLs,
                currentIndex: $carouselIndex,
                isShowingImageExtensionView: $isShowingImageExtensionView
            )
        }
    }
    
    private func reviewContentView(reviewDetail: ReviewDetail) -> some View {
        VStack(alignment: .leading) {
            Text("\(reviewDetail.content)")
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                
                Text(String(format: "%.1f", reviewDetail.rating))
                
                Spacer()
                
                Text("\(reviewDetail.dateString.iso8601ToDate?.toString(format: .yeatMonthDay) ?? "")")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                    .padding(.trailing)
            }
        }
        .padding(.leading)
    }
    
    private func reviewReplyView(reply: Reply, studioProfileImageString: URL) -> some View {
        HStack(alignment: .top) {
            ProfileImageView(imageURL: studioProfileImageString, size: 40)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(reply.studioName)")
                        .fontWeight(.bold)
                    
                    Text("\(day ?? "알 수 없음")")
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
    
    private func leadingToolbarContent(
        for studio: Studio
    ) -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            HStack {
                ProfileImageView(
                    imageURL: studio.profileImageURL,
                    size: 40
                )
                
                Text("\(tempUserName)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReviewDetailView()
    }
}
