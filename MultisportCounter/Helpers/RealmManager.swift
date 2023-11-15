//
//  RealmManager.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 15/11/2023.
//

import Foundation
import RealmSwift

final class RealmManager: ObservableObject {
    static let shared = RealmManager()
    
    func configureRealm() {
        let config = Realm.Configuration(schemaVersion: 4)
        Realm.Configuration.defaultConfiguration = config
        _ = try? Realm()
    }
}

