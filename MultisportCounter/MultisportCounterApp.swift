//
//  MultisportCounterApp.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 04/11/2023.
//

import SwiftUI

@main
struct MultisportCounterApp: App {
    init() {
        RealmManager.shared.configureRealm()
    }
    
    var body: some Scene {
        WindowGroup {
            DashboardScreen(viewModel: DashboardViewModel())
        }
    }
}
