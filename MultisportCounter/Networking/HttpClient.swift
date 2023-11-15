//
//  HttpClient.swift
//  TravelApp
//
//  Created by Patryk Jastrzębski on 10/06/2023.
//

import Foundation
import Combine

protocol HttpClient {
    func perform<T: Decodable>(_ request: HttpRequest) async throws -> T
    func perform(imagePath: String) async throws -> Data
}

final class HttpClientImpl: HttpClient {
    static let shared = HttpClientImpl()

    private var urlSesion: URLSession
    private var locale: Locale

    private init(urlSesion: URLSession = .shared, locale: Locale = .current) {
        self.urlSesion = urlSesion
        self.locale = locale
    }

    func perform<T: Decodable>(_ request: HttpRequest) async throws -> T {
        guard var components = URLComponents(string: request.url) else {
            throw AppError.invalidURL
        }
        
        if request.method == .get && request.body == nil {
            components.queryItems = components.queryItems != nil ? components.queryItems : [URLQueryItem]()
            components.queryItems?.append(contentsOf: request.parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            })
        }

        guard let url = components.url else {
            throw AppError.httpError
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        urlRequest.allHTTPHeaderFields = request.headers
        let (data, response) = try await urlSesion.data(for: urlRequest)
        log(.info, .networkResponse, try? JSONSerialization.jsonObject(with: data))

        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            print(response)
            throw AppError.httpError
        }
        
        let result = try JSONDecoder().decode(T.self, from: data)
        
        return result
    }

    func perform(imagePath: String) async throws -> Data {
        guard let url = URL(string: imagePath) else {
            throw AppError.urlError
        }
        let request = URLRequest(url: url)
        let (data, response) = try await urlSesion.data(for: request)
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw AppError.httpError
        }
        return data
    }
}

struct EmptyData: Codable {}
