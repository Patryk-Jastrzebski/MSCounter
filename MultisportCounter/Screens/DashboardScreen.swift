//
//  DashboardScreen.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 04/11/2023.
//

import SwiftUI
import RealmSwift

struct DashboardScreen: View {
    @StateObject var viewModel: DashboardViewModel
    
    @ObservedResults(Entry.self) var entries
    
    var body: some View {
        NavigationView {
            List {
                Section("Wejścia Listopad 2023") {
                    ForEach(entries) { entry in
                        entryRow(entry)
                    }
                    .onDelete(perform: viewModel.$entries.remove)
                    
                    
                    entryRow(.mock)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    addItemButton
                }
            }
            .navigationTitle("MultiSport+ 🧪")
            .sheet(isPresented: $viewModel.showAddNewEntryScreen) {
                AddNewEntryScreen(viewModel: AddNewEntryViewModel())
            }
        }
    }
    
    private func entryRow(_ entryData: Entry) -> some View {
        NavigationLink {
            EntryDetailsScreen(entry: entryData)
                .environmentObject(viewModel)
        } label: {
            HStack {
                Text("\(entryData.count)")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(8)
                    .background(Color.indigo)
                    .cornerRadius(6)
                
                Rectangle()
                    .frame(width: 2)
                    .padding(.vertical, 8)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading) {
                    if let name = entryData.msEntry?.name,
                       let city = entryData.msEntry?.city {
                        Text(name)
                            .font(.subheadline)
                        
                        Text(viewModel.getFormattedDate(date: entryData.date, .default))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Text(city)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.leading, 8)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var addItemButton: some View {
        Button {
            viewModel.showAddNewEntryScreen = true
        } label: {
            Image(systemName: "plus")
        }
    }
}

struct DashboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashboardScreen(viewModel: DashboardViewModel())
    }
}
