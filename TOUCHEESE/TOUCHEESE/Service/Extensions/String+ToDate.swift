//
//  String+ToDate.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/29/24.
//

import Foundation

extension String {
    func toDate(dateFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        return dateFormatter.date(from: self)
    }
    
    /// ISO8601(2023-12-02T10:15:30) 형식의 String을 Date 값으로 계산하는 변수
    var iso8601ToDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current // 로컬 시간대로 간주
        return formatter.date(from: self)
    }
}
