//
//  MSEntry.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 15/11/2023.
//

import Foundation

struct MSEntry: Codable {
    let name: String?
    let address: String?
    let city: String?
    
    var persistable: PersistableMSEntry {
        PersistableMSEntry(id: ._rlmDefaultValue(), name: name, address: address, city: city)
    }
}

extension MSEntry {
    static let mock = MSEntry(name: "Jasna Sport i Rekreacja MOCK", address: "ul. Jasna 31 MOCK", city: "Gliwice MOCK")
}
