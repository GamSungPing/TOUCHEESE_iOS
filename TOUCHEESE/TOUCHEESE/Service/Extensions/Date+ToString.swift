//
//  Date+ToString.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/30/24.
//

import Foundation

extension Date {
    func toString(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}
