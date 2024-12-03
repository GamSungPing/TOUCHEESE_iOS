//
//  DateFormat.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/29/24.
//

import Foundation

enum DateFormat: String {
    case hourMinute = "HH:mm"
    case monthDayTime = "MM월 dd일 HH:mm"
    case yearMonth = "yyyy년 MM월"
    case yearMonthDay = "yyyy.M.d."
    
    func toDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}
