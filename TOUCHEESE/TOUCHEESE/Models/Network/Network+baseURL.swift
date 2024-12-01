//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation

extension Network {
    func getBaseURL() -> String {
        let server_url = Bundle.main.serverURL
        
        switch self {
        case .studioRequest, .studioDetailRequest:
            return "\(server_url)/api/v1/studio"
        }
    }
}
