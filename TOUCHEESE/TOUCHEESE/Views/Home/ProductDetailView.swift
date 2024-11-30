//
//  ProductDetailView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/26/24.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    // 임시 뷰모델
    @EnvironmentObject private var productDetailViewModel: TempProductDetailViewModel
    
    // 캘린더 시트 트리거
    @State private var isCalendarPresented = true
    
    var body: some View {
        VStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // 상단 상품 이미지 및 설명
                        infoView(product: productDetailViewModel.product)
                            .padding(.bottom, 6)
                        
                        // 리뷰로 이동하는 버튼
                        reviewButtonView(reviewCount: productDetailViewModel.product.reviewCount)
                            .padding(.bottom, 10)
                        
                        // 가격 정보
                        priceView(productPrice: productDetailViewModel.product.price)
                            .padding(.bottom, 6)
                        
                        // 구분선
                        myDivider
                            .padding(.bottom, 10)
                        
                        // 기준 인원 뷰
                        baseGuestCountView(baseGuestCount: productDetailViewModel.productDetail.baseGuestCount!)
                            .padding(.bottom, 6)
                        
                        // 구분선
                        myDivider
                            .padding(.bottom, 10)
                        
                        // 단체 인원 뷰
                        AddPeopleView()
                            .padding(.bottom, 6)
                        
                        // 구분선
                        myDivider
                            .padding(.bottom, 10)
                        
                        // 상품 옵션 설정 뷰
                        productOptionView(productDetail: productDetailViewModel.productDetail)
                            .padding(.bottom, 12)
                        
                        // 구분선
                        myDivider
                            .padding(.bottom, 10)
                        
                        // 촬영 날짜 예약 뷰
                        reservationView(isCalendarPresented: $isCalendarPresented)
                    }
                }
                // 하단 장바구니, 주문 뷰
                bottomView()
            }
        }
        .sheet(isPresented: $isCalendarPresented) {
            // 예약할 날짜를 선택하는 캘린더 뷰
            calendarView(selectedDate: $productDetailViewModel.selectedDate, isCalendarPresented: $isCalendarPresented)
            .presentationDetents([.fraction(0.65)])
            .presentationDragIndicator(.visible)
        }
    }
    
    private var myDivider: some View {
        Rectangle()
            .frame(width: .infinity, height: 2.0)
            .foregroundStyle(.tcLightgray)
            .padding(.horizontal, 26)
    }
    
    @ViewBuilder
    private func infoView(product: Product) -> some View {
        // 이미지 넓이 값
        let imageWidth: CGFloat = 150
        // 이미지 넓이 - 높이 비율
        let imageScale: CGFloat = 1.5
        
        VStack {
            Image(systemName: "house.fill")
                .resizable()
                .frame(width: imageWidth, height: imageWidth * imageScale)
            
            Text(product.name)
                .font(.largeTitle)
            
            Text(product.description)
                .font(.footnote)
                .frame(width: 280)
                .padding(.bottom, 30)
        }
        .frame(width: CGFloat.screenWidth)
        .background(Color.tcBackground)
    }
    
    @ViewBuilder
    private func reviewButtonView(reviewCount: Int) -> some View {
        if reviewCount != 0 {
            HStack {
                Button {
                    print("리뷰 보러가기 동작")
                } label: {
                    Text("리뷰 \(reviewCount)개 보러가기 >")
                        .foregroundStyle(.black)
                        .font(.footnote)
                }
                .padding(.leading, 22)
                
                Spacer()
            }
        }
    }
    
    private func priceView(productPrice: Int) -> some View {
        HStack {
            Text("가 격")
            
            Spacer()
            
            Text("\(productPrice.moneyStringFormat)")
        }
        .font(.headline)
        .fontWeight(.semibold)
        .padding(.horizontal, 45)
    }
    
    private func baseGuestCountView(baseGuestCount: Int) -> some View {
        HStack {
            Text("기준 인원")
            
            Spacer()
            
            Text("\(baseGuestCount) 명")
        }
        .font(.headline)
        .fontWeight(.semibold)
        .padding(.horizontal, 45)
    }
    
    private struct AddPeopleView: View {
        // 임시 뷰모델
        @EnvironmentObject private var productDetailViewModel: TempProductDetailViewModel
        
        var body: some View {
            HStack {
                Text("추가 인원 (\(productDetailViewModel.getAddPeoplePrice()))")
                
                Spacer()
                
                Button {
                    productDetailViewModel.decreaseAddPeopleCount()
                } label: {
                    Image(systemName: "minus.square.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.black, Color.gray)
                }
                
                Text("\(productDetailViewModel.addPeopleCount) 명")
                
                Button {
                    productDetailViewModel.increaseAddPeopleCount()
                } label: {
                    Image(systemName: "plus.square.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.black, Color.gray)
                }
                
            }
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.horizontal, 45)
        }
    }
    
    private struct optionItemView: View {
        // 임시 뷰모델
        @EnvironmentObject private var productDetailViewModel: TempProductDetailViewModel
        @State var isSelected: Bool = false
        let productOption: ProductOption
        
        var body: some View {
            HStack {
                Button {
                    isSelected.toggle()
                    productDetailViewModel.optionChanged(isSelected: isSelected, id: productOption.id)
                } label: {
                    Circle()
                        .frame(width: 25)
                        .foregroundStyle(Color.tcYellow)
                        .overlay(
                            Circle()
                                .frame(width: 15)
                                .foregroundStyle(isSelected ? Color.blue : Color.clear)
                        )
                }
                .padding(.trailing, 22)
                
                Text("\(productOption.name)")
                
                Spacer()
                
                Text("\(productOption.price.moneyStringFormat)")
            }
            .padding(.horizontal, 30)
        }
    }
    
    @ViewBuilder
    private func productOptionView(productDetail: ProductDetail) -> some View {
        if !productDetail.productOptions.isEmpty {
            VStack {
                HStack {
                    Text("추가 구매")
                        .font(.footnote)
                        .padding(.leading, 22)
                    
                    Spacer()
                }
                
                ForEach(productDetail.productOptions) { option in
                    optionItemView(productOption: option)
                }
            }
        }
    }
    
    private struct reservationView: View {
        @State var isOpen: Bool = false
        @Binding var isCalendarPresented: Bool
        @EnvironmentObject private var productDetailViewModel: TempProductDetailViewModel
        
        var body: some View {
            VStack {
                HStack {
                    Text("촬영날짜")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 30)
                    
                    Spacer()
                }
                
                Button {
                    isCalendarPresented.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: .infinity, height: 60)
                        .foregroundStyle(Color.tcLightgray)
                        .overlay {
                            if productDetailViewModel.reservationDate == nil {
                                Text("예약하실 날짜를 선택해주세요")
                                    .foregroundStyle(.black)
                            } else {
                                Text("예약 날짜:  \(productDetailViewModel.reservationDate!.toString(format: .monthDayTime))")
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private struct bottomView: View {
        // 임시 뷰모델
        @EnvironmentObject private var productDetailViewModel: TempProductDetailViewModel
        
        var body: some View {
            HStack(spacing: 12) {
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 80, height: 40)
                        .foregroundStyle(Color.tcYellow)
                        .overlay {
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .foregroundStyle(Color.black)
                        }
                }
                
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: .infinity, height: 40)
                        .foregroundStyle(Color.tcYellow)
                        .overlay {
                            Text("선택 상품 주문(\(productDetailViewModel.totalPrice))")
                                .foregroundStyle(.black)
                        }
                }
            }
            .padding(.horizontal, 30)
        }
    }
    
    private struct calendarView: View {
        // 임시 뷰모델
        @EnvironmentObject private var productDetailViewModel: TempProductDetailViewModel
        // 선택된 날짜
        @Binding var selectedDate: Date
        @Binding var isCalendarPresented: Bool
        
        var body: some View {
            ScrollView(showsIndicators: false) {
                VStack {
                    DatePicker("달력", selection: $selectedDate, in: Date()...,displayedComponents: .date)
                        .accentColor(.tcYellow)
                        .datePickerStyle(.graphical)
                        .environment(\.locale, Locale(identifier: "ko_KR"))

                    LazyVGrid(columns: productDetailViewModel.businessHourColums) {
                        ForEach(productDetailViewModel.businessHour, id: \.self) { time in
                            Button {
                                productDetailViewModel.selectTime(time: time)
                                isCalendarPresented = false
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(.tcLightyellow)
                                    .frame(height: 30)
                                    .overlay {
                                        Text("\(time)")
                                            .foregroundStyle(.black)
                                    }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
}

#Preview {
    ProductDetailView()
        .environmentObject(TempProductDetailViewModel())
}
