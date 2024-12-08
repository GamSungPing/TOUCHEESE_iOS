//
//  ReservationStatus.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

enum ReservationStatus: String {
    case waiting
    case confirm
    case complete
    case cancel
    
    var description: String {
        switch self {
        case .waiting: "예약 대기"
        case .confirm: "예약 확정"
        case .complete: "예약 완료"
        case .cancel: "예약 취소"
        }
    }
}
