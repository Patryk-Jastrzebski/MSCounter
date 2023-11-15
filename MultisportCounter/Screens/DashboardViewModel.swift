//
//  DashboardViewModel.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 04/11/2023.
//

import Combine
import Foundation
import RealmSwift
import SwiftUI
import MapKit
import CoreLocation

final class DashboardViewModel: NSObject, ObservableObject {
    @AppStorage(String.isFirstStartAPS) var isFirstStart = false
    @Published var showAddNewEntryScreen = false
    
    // MARK: - Realm object DB
    @ObservedResults(Entry.self) var entries
    
    private var cancellables = Set<AnyCancellable>()
    private var dateFormatter: DateFormatterHelper
    
    let locationManager = CLLocationManager()

    init(dateFormatter: DateFormatterHelper = .shared) {
        self.dateFormatter = dateFormatter
    }
    
    func getFormattedDate(date: Date?, _ format: DateFormat) -> String {
        dateFormatter.string(from: date, format: format, withTimeZone: true) ?? "unknown date"
    }
}

extension DashboardViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

}
