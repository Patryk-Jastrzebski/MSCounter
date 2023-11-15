//
//  HttpRequest.swift
//  TravelApp
//
//  Created by Patryk Jastrzębski on 10/06/2023.
//

import Foundation

typealias Parameters = [String: Any]
typealias Headers = [String: String]
typealias RequestParameters = [String: Any]

class HttpRequest {
    let url: String
    let method: HttpMethod
    let parameters: Parameters
    let body: Data?
    var headers: Headers

    init(url: String,
         method: HttpMethod,
         parameters: Parameters = [:],
         headers: Headers = HeaderFactory.createHeaders([]),
         body: Data? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
    
    convenience init<P: Encodable>(url: String,
                                   method: HttpMethod,
                                   parameters: P,
                                   headers: Headers = HeaderFactory.createHeaders([])) {
        let params: RequestParameters
        do {
            params = try DictionaryEncoder.dictionary(from: parameters)
        } catch {
            params = [:]
        }
        self.init(url: url, method: method, parameters: params, headers: headers)
    }
    
    var string: String {
        """
        [\(method.rawValue.uppercased())] \(url)
        Parameters: \(parameters)
        Headers: \(headers.description)
        """
    }
}

enum HeaderType {
    case formData(String)
    
    var headerValue: (key: String, value: String) {
        switch self {
        case let .formData(boundary):
            return ("Content-Type", "multipart/form-data; boundary=\(boundary)")
        }
    }
}

final class HeaderFactory {
    static func createHeaders(_ types: [HeaderType]) -> Headers {
        var headers: Headers = [:]
        
        for type in types {
            if !type.headerValue.key.isEmpty {
                headers[type.headerValue.key] = type.headerValue.value
            }
        }
        
        return headers
    }
}

enum EncoderError: Error {
    case invalidObject(Any)
}

final class DictionaryEncoder {
    static func dictionary<Value: Encodable>(from value: Value) throws -> [String: Any] {
        let data = try JSONEncoder.default.encode(value)
        guard let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw EncoderError.invalidObject(value)
        }
        return dict
    }
}

extension JSONEncoder {
    static var `default`: JSONEncoder = {
        let encoder = JSONEncoder()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        encoder.dateEncodingStrategy = .custom { date, encoder in
            let str = dateFormatter.string(from: date)
            try str.encode(to: encoder)
        }

        return encoder
    }()
}
