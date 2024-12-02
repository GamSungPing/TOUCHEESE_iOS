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
            VStack(alignment: .leading) {
                DividerView(horizontalPadding: 0, color: .tcLightyellow)
                
                ImageCarouselView(
                    imageURLs: reviewDetail.imageURLs,
                    carouselIndex: $carouselIndex,
                    isShowingImageExtensionView: $isShowingImageExtensionView,
                    height: 340
                )
                .padding(.bottom, 15)
                
                Group {
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
                .padding(.leading, 15)
                
                DividerView(horizontalPadding: 10)
                    .padding(.bottom)
                
                Group {
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
                }
                .padding(.leading, 15)
                
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
