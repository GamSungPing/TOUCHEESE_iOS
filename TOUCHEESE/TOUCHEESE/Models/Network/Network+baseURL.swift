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
        case .testRequestType:
            return "https://jsonplaceholder.typicode.com"
        case .conceptRequestType:
            return "\(server_url)/api/v1/studio/concept/"
        case .tempStudioRequest:
            return "\(server_url)/api/v1/studio"
        }
    }
}
