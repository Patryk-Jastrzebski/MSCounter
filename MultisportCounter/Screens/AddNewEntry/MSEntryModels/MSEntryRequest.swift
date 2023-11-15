//
//  MSEntryRequest.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 15/11/2023.
//

import Foundation

struct MSEntryRequest: Codable {
    let name: String
    let limit: Int
    let suggestions: Int
    
    init(city: String, street: String, limit: Int = 10, suggestions: Int = 1) {
        self.name = "\(city) + \(street)"
        self.limit = limit
        self.suggestions = suggestions
    }
}
