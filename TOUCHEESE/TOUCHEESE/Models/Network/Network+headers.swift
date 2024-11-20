//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getHeaders() -> HTTPHeaders? {
        switch self {
        case .testRequestType:
            return ["Content-Type": "application/json"]
        case .conceptRequestType:
            return ["Content-Type": "application/json"]
        case .tempStudioRequest:
            return ["Content-Type": "application/json"]
        }
    }
}
