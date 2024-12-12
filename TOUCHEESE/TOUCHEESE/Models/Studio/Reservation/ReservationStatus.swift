//
//  ReservationStatus.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation
import SwiftUICore

enum ReservationStatus: String {
    case waiting
    case confirm
    case complete
    case cancel
    
    var description: String {
        switch self {
        case .waiting: "예약 대기"
        case .confirm: "예약 확정"
        case .complete: "촬영 완료"
        case .cancel: "예약 취소"
        }
    }
    
    var color: (font: Color, background: Color, stroke: Color) {
        switch self {
        case .waiting: (.tcGray09, .tcGray03, .tcGray03)
        case .confirm: (.tcPrimary07, .clear, .tcPrimary07)
        case .complete: (.tcGray09, .tcPrimary05, .tcPrimary05)
        case .cancel: (.tcError, .clear, .tcError)
        }
    }
}
