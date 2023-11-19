//
//  AddNewEntryScreen.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 08/11/2023.
//

import SwiftUI
import MapKit
import Combine
import RealmSwift

final class AddNewEntryViewModel: NSObject, ObservableObject, BaseViewModel {
    // MARK: BaseViewModel variables
    var defaultErrorDescription: String = "Nie udało się pobrać obiektu"
    @Published var apiErrorDescription: String?
    @Published var apiError = false
    @Published var isLoading = true
    
    // MARK: Publishers
    @Published var date: Date? = Date()
    @Published var numberOfEntries = "1"
    @Published var msResponse: MSResponse?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.125736, longitude: 19.080392),
                                               span: MKCoordinateSpan(latitudeDelta: 6.5, longitudeDelta: 6.5))
    
    let dateFormatter: DateFormatterHelper
    
    @ObservedResults(Entry.self) var entries
    
    // MARK: Private
    private let service: NewEntryService
    private var userLocation: UserLocation?
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(dateFormatter: DateFormatterHelper = .shared,
         locationManager: LocationManager = LocationManager(),
         service: NewEntryService = NewEntryServiceImpl()) {
        self.dateFormatter = dateFormatter
        self.locationManager = locationManager
        self.service = service
        super.init()
        setupBindings()
    }
    
    var formattedDate: String {
        dateFormatter.string(from: date, format: .dateAndTimeWithPartialMonth, withTimeZone: false) ?? ""
    }
    
    func saveEntry() {
        guard let count = Int(numberOfEntries),
              let date = date else {
            return
        }
        
        let entry = Entry(id: ._rlmDefaultValue(),
                          count: count,
                          date: date,
                          msEntry: msResponse?.msNearObject?.persistable)
        
        $entries.append(entry)
    }
    
    fileprivate func setupBindings() {
        locationManager.$userLocation
            .compactMap { $0 }
            .sink { [weak self] userLocation in
                self?.userLocation = userLocation
                self?.fetchMSLocation()
                self?.setupUserRegion(userLocation)
            }
            .store(in: &cancellables)
    }
    
    fileprivate func fetchMSLocation() {
        Task {
            guard let userLocation else { return }
            await apiFunction(data: (userLocation.city, userLocation.street),
                              with: service.getPlace,
                              successAction: { [weak self] response in
                self?.msResponse = response
            })
        }
    }
    
    fileprivate func setupUserRegion(_ userLocation: UserLocation) {
        withAnimation {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.lat, longitude: userLocation.lon),
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
    }
}

struct AddNewEntryScreen: View {
    @StateObject var viewModel: AddNewEntryViewModel
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                mapView
                
                List {
                    entryDateView
                    counterView
                    loadableEntryView
                }
            }
            
            saveButton
        }
    }
    
    private var entryDateView: some View {
        HStack {
            Text("Data wejścia:")
                .foregroundColor(.secondary)
            DatePickerInputView(date: $viewModel.date,
                                placeholder: "Data",
                                dateFormatter: viewModel.dateFormatter)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private var counterView: some View {
        HStack {
            Text("Ilość wejść: ")
                .foregroundColor(.secondary)
            TextField("", text: $viewModel.numberOfEntries)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.blue)
        }
    }
    
    private var mapView: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true)
            .ignoresSafeArea()
            .allowsHitTesting(false)
            
            ModalViewTopIndicator()
        }
        .frame(height: 240)
    }
    
    private var saveButton: some View {
        VStack {
            Spacer()
            Button {
                viewModel.saveEntry()
                dismiss()
            } label: {
                Text("Zapisz")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.blue)
                    .cornerRadius(10, antialiased: true)
                    .shadow(color: .black.opacity(0.25),
                            radius: 4,
                            x: 0,
                            y: 1)
                    .padding(16)
            }
        }
    }
    
    private var emptyResponseView: some View {
        Text("Nie znaleziono obiektów ☹️")
    }
    
    @ViewBuilder private var loadableEntryView: some View {
        Section("Obiekt sportowy") {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.apiErrorDescription,
                      viewModel.apiError {
                ErrorView(error: error)
            } else if let msObject = viewModel.msResponse?.msNearObject {
                NearEntryView(msObject: msObject)
            } else {
                emptyResponseView
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct AddNewEntryScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddNewEntryScreen(viewModel: AddNewEntryViewModel())
    }
}
