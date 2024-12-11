//
//  ProductDetailViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/3/24.
//

import Foundation

final class ProductDetailViewModel: ObservableObject {
    // MARK: - Data
    let networkManager = NetworkManager.shared
    
    @Published private(set) var studio: Studio
    @Published private(set) var studioDetail: StudioDetail
    @Published private(set) var product: Product
    @Published private(set) var productDetail: ProductDetail = ProductDetail.sample1
    
    // 예약한 날짜
    @Published private(set) var reservationDate: Date?
    
    // 총 가격
    @Published private(set) var totalPrice: Int = 0
    
    // 영업 시간 배열
    @Published private(set) var businessHourAM: [String] = []
    @Published private(set) var businessHourPM: [String] = []
    
    // 추가 인원 변수
    @Published private(set) var addPeopleCount: Int = 0 {
        didSet {
            calTotalPrice()
        }
    }
    
    // 선택된 옵션의 ID Set
    private var selectedOptionIDArray: Set<Int> = [] {
        didSet {
            calTotalPrice()
        }
    }
    
    // 선택된 시간
    @Published var selectedTime: Date?
    
    // 선택된 날짜
    @Published var selectedDate: Date = Date()
    
    // 선택된 옵션 배열
    var selectedProductOptionArray: [ProductOption] {
        productDetail.parsedProductOptions.filter { selectedOptionIDArray.contains($0.id) }
    }
    
    // MARK: - Init
    init(studio: Studio, studioDetails: StudioDetail, product: Product) {
        self.studio = studio
        self.studioDetail = studioDetails
        self.product = product
        
        Task {
            await fetchProductDetail()
        }
        
        calTotalPrice()
        calBusinessHour()
    }
    
    // MARK: - Input
    func increaseAddPeopleCount() {
        addPeopleCount += 1
    }
    
    func decreaseAddPeopleCount() {
        if addPeopleCount > 0 {
            addPeopleCount -= 1
        }
    }
    
    /// 상품의 옵션을 선택/취소했을 때 동작하는 함수
    func optionChanged(isSelected: Bool, id: Int) {
        if isSelected {
            selectedOptionIDArray.insert(id)
        } else {
            selectedOptionIDArray.remove(id)
        }
    }
    
    /// 상품의 예약 시간을 선택했을 때 동작하는 함수
    func selectTime(time: String) {
        selectedTime = time.toDate(dateFormat: .hourMinute)
    }
    
    /// 상품의 예약 날짜를 선택했을 때 동작하는 함수
    func selectDate(date: Date) {
        selectedDate = date
    }
    
    // MARK: - Output
    /// 인원 추가 가격을 문자열로 리턴하는 함수
    func getAddPeoplePrice() -> String {
        guard let addPeoplePrice = productDetail.addPeoplePrice?.moneyStringFormat else { return "" }
        return addPeoplePrice
    }
    
    // MARK: - Logic
    @MainActor
    /// ProductDetail 정보를 네트워크 통신을 통해 가져오는 함수
    private func fetchProductDetail() async {
        do {
            productDetail = try await networkManager.getProductDetailData(productID: product.id)
        } catch {
            print("Fetch ProductDetail Error: \(error.localizedDescription)")
        }
    }
    
    /// 상품의 총 가격을 계산하는 함수
    private func calTotalPrice() {
        var totalPrice: Int = 0
        
        // 상품 기본 가격 추가
        totalPrice += product.price
        
        // 단체 인원별 가격 추가
        totalPrice += (productDetail.addPeoplePrice ?? 0) * addPeopleCount
        
        // 옵션 별 상품 가격 추가
        for option in productDetail.parsedProductOptions {
            if selectedOptionIDArray.contains(option.id) {
                totalPrice += option.price
            }
        }
        
        self.totalPrice = totalPrice
    }
    
    private func calBusinessHour() {
        let calendar = Calendar.current
        
        guard let openTime = studioDetail.openTimeString.toDate(dateFormat: .hourMinute) else { return }
        guard let closeTime = studioDetail.closeTimeString.toDate(dateFormat: .hourMinute) else { return }
        
        var amTimes: [String] = []
        var pmTimes: [String] = []
        var currentTime = openTime
        
        while currentTime < closeTime {
            // 현재 시간을 포맷에 맞게 변환
            let timeString = DateFormat.hourMinute.toDateFormatter().string(from: currentTime)
            
            // 오전/오후로 나누기
            let hour = calendar.component(.hour, from: currentTime)
            if hour < 12 {
                amTimes.append(timeString)
            } else {
                pmTimes.append(timeString)
            }
            
            // 1시간씩 추가
            if let nextTime = calendar.date(byAdding: .hour, value: 1, to: currentTime) {
                currentTime = nextTime
            } else {
                break
            }
        }
        
        // 종료 시간이 분 단위로 남아 있는 경우 마지막 시간 추가
        if calendar.compare(currentTime, to: closeTime, toGranularity: .minute) != .orderedSame {
            let timeString = DateFormat.hourMinute.toDateFormatter().string(from: closeTime)
            let hour = calendar.component(.hour, from: closeTime)
            if hour < 12 {
                amTimes.append(timeString)
            } else {
                pmTimes.append(timeString)
            }
        }
        
        // 결과 할당
        businessHourAM = amTimes
        businessHourPM = pmTimes
    }
    
    /// 총 예약 가격을 계산하는 함수
    func calReservationDate() {
        guard let selectedTime else { return }
        
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        
        var reservationDate = DateComponents()
        reservationDate.year = dateComponents.year
        reservationDate.month = dateComponents.month
        reservationDate.day = dateComponents.day
        reservationDate.hour = timeComponents.hour
        reservationDate.minute = timeComponents.minute
        
        self.reservationDate = calendar.date(from: reservationDate)
    }
}
