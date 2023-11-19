//
//  BaseUrl.swift
//  TravelApp
//
//  Created by Patryk Jastrzębski on 10/06/2023.
//

import Foundation
import Combine
import IteoLogger

struct Configuration {
    let serverUrlProtocol = "https"
    let serverUrlHost = "wys.benefitsystems.pl/api"
    let map = "/map"
}

//    https://wys.benefitsystems.pl/api/v2/map/bounds/matching/40/20/40/20?name=Gliwice+Jasna&limit=10&suggestions=1

enum UrlFeaturePath: String {
    case product = "/product"
}

class BaseNetworking {

    let configuration = Configuration()
    private let manager: HttpClient
    
    internal var baseUrl: String {
        "\(configuration.serverUrlProtocol)://\(configuration.serverUrlHost)\(APIVersion.v2.path)\(configuration.map)"
    }

    init(manager: HttpClient = HttpClientImpl.shared) {
        self.manager = manager
    }

    func perform<T: Codable>(_ request: HttpRequest) async throws -> T {
        do {
            return try await manager.perform(request)
        } catch {
            log(.error, .network, error.localizedDescription)
            throw error
        }
    }
}
