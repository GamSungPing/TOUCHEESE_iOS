//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getMethod() -> HTTPMethod {
        switch self {
        case .testRequestType:
            return .get
        case .conceptRequestType:
            return .get
        case .tempStudioRequest:
            return .get
        }
    }
}
