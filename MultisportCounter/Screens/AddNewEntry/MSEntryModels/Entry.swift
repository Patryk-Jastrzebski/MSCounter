//
//  Entry.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 04/11/2023.
//

import Foundation
import RealmSwift
import CoreLocation


class Entry: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var count: Int
    @Persisted var date: Date
    @Persisted var msEntry: PersistableMSEntry?

    convenience init(id: ObjectId, count: Int, date: Date, msEntry: PersistableMSEntry?) {
        self.init()
        self.id = id
        self.count = count
        self.date = date
        self.msEntry = msEntry
    }
}

extension Entry {
    static let mock = Entry(id: ._rlmDefaultValue(),
                            count: 1,
                            date: Date(),
                            msEntry: .init(id: ._rlmDefaultValue(),
                                           name: "Obiekt sportowy Jasna",
                                           address: "Jasna 31 Sport",
                                           city: "Gliwice"))
}
