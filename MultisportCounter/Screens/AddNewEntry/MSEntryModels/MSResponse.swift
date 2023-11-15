//
//  MSResponse.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 15/11/2023.
//

import Foundation

struct MSMatchingEntry: Codable {
    let docs: [MSEntry]
}

struct MSResponse: Codable {
    let response: MSEntryResponse?
    
    var msNearObject: MSEntry? {
        response?.matchingAll?.docs.first
    }
    
    var msSuggestedObjects: [MSEntry]? {
        response?.matchingSome?.docs
    }
}

struct MSEntryResponse: Codable {
    let matchingAll: MSMatchingEntry?
    let matchingSome: MSMatchingEntry?
    
    enum CodingKeys: String, CodingKey {
        case matchingAll = "matching_all"
        case matchingSome = "matching_some"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.matchingAll = try container.decodeIfPresent(MSMatchingEntry.self, forKey: .matchingAll)
        self.matchingSome = try container.decodeIfPresent(MSMatchingEntry.self, forKey: .matchingSome)
    }
}
