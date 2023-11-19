//
//  APIVersion.swift
//  TravelApp
//
//  Created by Patryk Jastrzębski on 10/06/2023.
//

import Foundation

enum APIVersion {
    case blank
    case v1
    case v2
    
    var path: String {
        switch self {
        case .blank:
            return ""
        case .v1:
            return "/v1"
        case .v2:
            return "/v2"
        }
    }
}
