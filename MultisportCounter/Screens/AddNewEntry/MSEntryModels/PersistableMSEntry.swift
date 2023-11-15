//
//  PersistableMSEntry.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 15/11/2023.
//

import Foundation
import RealmSwift

class PersistableMSEntry: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var name: String?
    @Persisted var address: String?
    @Persisted var city: String?
    
    convenience init(id: ObjectId, name: String?, address: String?, city: String?) {
        self.init()
        self.id = id
        self.name = name
        self.address = address
        self.city = city
    }
}
