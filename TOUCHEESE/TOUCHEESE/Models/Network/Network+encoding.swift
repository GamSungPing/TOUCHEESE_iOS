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
        case .studioRequest, .studioDetailRequest:
            return URLEncoding.default
        }
    }
}
