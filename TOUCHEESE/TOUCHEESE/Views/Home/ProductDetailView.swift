//
//  ProductDetailView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/26/24.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    @StateObject var productDetailViewModel: ProductDetailViewModel
    
    // 캘린더 시트 트리거
    @State private var isCalendarPresented = false
    
    var body: some View {
        let product = productDetailViewModel.product
        let productDetail = productDetailViewModel.productDetail
        
        ZStack {
            VStack {
                Color.tcBackground
                    .frame(width: .screenWidth, height: 370)
                    .ignoresSafeArea()
                
                Spacer()
            }
            
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // 상단 상품 이미지 및 설명
                        infoView(product: product)
                            .padding(.bottom, 10)
                        
                        // 리뷰로 이동하는 버튼
                        //                        reviewButtonView(reviewCount: product.reviewCount)
                        //                            .padding(.bottom, 10)
                        
                        // 가격 정보
                        priceView(productPrice: product.price)
                            .padding(.bottom, 6)
                        
                        // 구분선
                        myDivider
                            .padding(.bottom, 10)
                        
                        if productDetail.isGroup {
                            // 기준 인원 뷰
                            baseGuestCountView(baseGuestCount: productDetail.basePeopleCnt ?? 0)
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
                        }
                        
                        if !productDetail.parsedProductOptions.isEmpty {
                            // 상품 옵션 설정 뷰
                            productOptionView(productDetail: productDetail)
                                .padding(.bottom, 12)
                            
                            // 구분선
                            myDivider
                                .padding(.bottom, 10)
                        }
                        
                        // 촬영 날짜 예약 뷰
                        ReservationView(isCalendarPresented: $isCalendarPresented)
                    }
                }
                // 하단 장바구니, 주문 뷰
                BottomView()
            }
            .toolbarRole(.editor)
            .environmentObject(productDetailViewModel)
            .sheet(isPresented: $isCalendarPresented) {
                // 예약할 날짜를 선택하는 캘린더 뷰
                CalendarView(isCalendarPresented: $isCalendarPresented, displayTime: productDetailViewModel.selectedTime?.toString(format: .hourMinute) ?? "", displayDate: productDetailViewModel.selectedDate)
                    .presentationDetents([.fraction(0.9)])
                    .presentationDragIndicator(.hidden)
                    .environmentObject(productDetailViewModel)
            }
        }
    }
    
    private var myDivider: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 2.0)
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
            KFImage(product.imageURL)
                .placeholder { ProgressView() }
                .resizable()
                .cancelOnDisappear(true)
                .fade(duration: 0.25)
                .aspectRatio(contentMode: .fit)
                .frame(width: imageWidth, height: imageWidth * imageScale)
            
            Text(product.name)
                .font(.largeTitle)
            
            Text(product.description)
                .font(.footnote)
                .frame(width: 280)
                .padding(.bottom, 30)
        }
        .frame(width: .screenWidth)
        .background(.tcBackground)
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
    
    @ViewBuilder
    private func productOptionView(productDetail: ProductDetail) -> some View {
        VStack {
            HStack {
                Text("추가 구매")
                    .font(.footnote)
                    .padding(.leading, 22)
                
                Spacer()
            }
            
            ForEach(productDetail.parsedProductOptions) { option in
                OptionItemView(productOption: option)
            }
        }
    }
}

fileprivate struct AddPeopleView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
    var body: some View {
        let addPeoplePrice = productDetailViewModel.getAddPeoplePrice()
        
        HStack {
            Text("추가 인원 (\(addPeoplePrice))")
            
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

fileprivate struct OptionItemView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
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

fileprivate struct ReservationView: View {
    @Binding var isCalendarPresented: Bool
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
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
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
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

fileprivate struct BottomView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tempNavigationManager: TempNavigationManager
    
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
                tempNavigationManager
                    .appendPath(
                        viewType: .reservationConfirmView,
                        viewMaterial: ReservationConfirmViewMaterial(
                            viewModel: ReservationViewModel(
                                studio: productDetailViewModel.studio,
                                studioDetail: productDetailViewModel.studioDetail,
                                product: productDetailViewModel.product,
                                productDetail: productDetailViewModel.productDetail,
                                productOptions: productDetailViewModel.selectedProductOptionArray,
                                reservationDate: productDetailViewModel.reservationDate ?? Date(),
                                totalPrice: productDetailViewModel.totalPrice,
                                addPeopleCount: productDetailViewModel.addPeopleCount
                            )
                        )
                    )
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .foregroundStyle(Color.tcYellow)
                    .overlay {
                        Text("선택 상품 주문 (\(productDetailViewModel.totalPrice.moneyStringFormat))")
                            .foregroundStyle(.black)
                    }
            }
        }
        .padding(.horizontal, 30)
    }
}

fileprivate struct CalendarView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    @Binding var isCalendarPresented: Bool
    
    @State var displayTime: String = ""
    @State var displayDate = Date()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    CustomCalendar(displayDate: $displayDate)
                    
                    DividerView()
                        .padding(.vertical, 8)
                    
                    VStack {
                        HStack {
                            Text("선택 가능한 시간대")
                                .font(.pretendardSemiBold18)
                                .foregroundStyle(.black)
                            
                            Spacer()
                        }
                        .padding(.bottom, 20)
                        
                        if !productDetailViewModel.businessHourPM.isEmpty {
                            HStack {
                                Text("오전")
                                    .font(.pretendardMedium14)
                                    .foregroundStyle(.tcGray09)
                                
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                ForEach(productDetailViewModel.businessHourAM, id: \.self) { time in
                                    Button {
                                        if !productDetailViewModel.selectedDate.isHoliday(holidays: productDetailViewModel.studioDetail.holidays) {
                                            displayTime = time
                                        }
                                    } label: {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(displayTime == time ? .clear : .tcGray03, lineWidth: 1)
                                            .frame(height: 40)
                                            .frame(idealWidth: 101)
                                            .background {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(displayTime == time ? .tcPrimary06 : .white)
                                                    .overlay {
                                                        Text(time)
                                                            .font(.pretendardMedium16)
                                                            .foregroundStyle(displayTime == time ? .white : .tcGray10)
                                                    }
                                            }
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        
                        if !productDetailViewModel.businessHourPM.isEmpty {
                            HStack {
                                Text("오후")
                                    .font(.pretendardMedium14)
                                    .foregroundStyle(.tcGray09)
                                
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                ForEach(productDetailViewModel.businessHourPM, id: \.self) { time in
                                    Button {
                                        if !productDetailViewModel.selectedDate.isHoliday(holidays: productDetailViewModel.studioDetail.holidays) {
                                            displayTime = time
                                        }
                                    } label: {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(displayTime == time ? .clear : .tcGray03, lineWidth: 1)
                                            .frame(height: 40)
                                            .frame(idealWidth: 101)
                                            .background {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(displayTime == time ? .tcPrimary06 : .white)
                                                    .overlay {
                                                        Text(time)
                                                            .font(.pretendardMedium16)
                                                            .foregroundStyle(displayTime == time ? .white : .tcGray10)
                                                    }
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    Button {
                        productDetailViewModel.selectedTime = displayTime.toDate(dateFormat: .hourMinute)
                        
                        productDetailViewModel.selectedDate = displayDate
                        
                        productDetailViewModel.calReservationDate()
                        isCalendarPresented = false
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 64)
                            .foregroundStyle(displayTime == "" ? .tcGray03 : .tcPrimary06)
                            .overlay {
                                Text("날짜 선택")
                                    .font(.pretendardBold20)
                                    .foregroundStyle(displayTime == "" ?  .tcGray05 : .tcGray10)
                            }
                    }
                    .disabled(displayTime == "" ? true : false)
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 32)
    }
}

fileprivate struct CustomCalendar: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
    // 캘린더 상단에 표시되는 기준 날짜
    @Binding var displayDate: Date
    @State private var displayMonth = Date()
    
    // 현재 날짜의 정보를 가져오는 계산 속성
    private var calendar: Calendar { Calendar.current }
    
    var body: some View {
        VStack {
            HStack {
                // 이전 달 버튼
                Button {
                    displayMonth = calendar.date(byAdding: .month, value: -1, to: displayMonth) ?? Date()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.tcPrimary06)
                        .padding(.leading, 8)
                }
                
                Spacer()
                
                // 현재 표시되는 날짜
                Text("\(displayMonth.toString(format: .yearMonth))")
                    .font(.pretendardSemiBold16)
                    .foregroundStyle(.tcGray10)
                
                Spacer()
                
                // 다음 달 버튼
                Button {
                    displayMonth = calendar.date(byAdding: .month, value: +1, to: displayMonth) ?? Date()
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.tcPrimary06)
                        .padding(.trailing, 8)
                }
            }
            .padding(.bottom, 16)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                // 요일 표시
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { weekday in
                    Text(weekday)
                        .frame(idealWidth: 50, idealHeight: 40)
                        .font(.pretendardMedium14)
                        .foregroundStyle(.tcGray10)
                }
                
                // 빈칸 표시
                ForEach(0..<displayMonth.firstWeekday - 1, id: \.self) { _ in
                    Text("")
                        .frame(idealWidth: 50, idealHeight: 40)
                }
                
                // 날짜 표시
                ForEach(displayMonth.daysInMonth, id: \.self) { date in
                    let isHoliday = date.isHoliday(holidays: productDetailViewModel.studioDetail.holidays)
                    
                    let isSelected = calendar.isDate(date, inSameDayAs: displayDate)
                    
                    Button {
                        displayDate = date
                    } label: {
                        Text("\(date.dayNumber)")
                            .font(isSelected ? .pretendardSemiBold14 : .pretendardMedium14)
                            .fontWeight(isSelected ? .semibold : .medium)
                            .foregroundStyle(
                                isSelected ? Color.white : (isHoliday || date.isPast ? .tcGray04 : .tcGray06))
                            .frame(idealWidth: 50, idealHeight: 40)
                            .background(
                                Circle()
                                    .fill(
                                        (isHoliday && isSelected) ? .tcPrimary06 : (isSelected ? .tcYellow : .clear)
                                    )
                                    .frame(width: 38, height: 38)
                            )
                    }
                    .disabled(isHoliday || date.isPast)
                }
            }
        }
        .onAppear {
            displayMonth = productDetailViewModel.selectedDate
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(productDetailViewModel: ProductDetailViewModel(studio: Studio.sample, studioDetails: StudioDetail.sample, product: Product.sample1))
            .environmentObject(NavigationManager())
    }
}
