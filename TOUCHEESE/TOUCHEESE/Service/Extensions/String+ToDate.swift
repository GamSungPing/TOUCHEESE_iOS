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
}
