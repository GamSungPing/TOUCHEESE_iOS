//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getEncoding() -> ParameterEncoding {
        switch self {
        case .testRequestType:
            return URLEncoding.default
        case .conceptRequestType:
            return URLEncoding.default
        case .tempStudioRequest:
            return URLEncoding.default
        }
    }
}
