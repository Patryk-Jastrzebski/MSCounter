//
//  NewEntryNetworking.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 12/11/2023.
//

import Foundation

protocol NewEntryService {
    func getPlace(city: String, street: String) async throws -> MSResponse
}

final class NewEntryServiceImpl: BaseNetworking, NewEntryService {
    let networking: NewEntryNetworking
    
    init(networking: NewEntryNetworking = NewEntryNetworkingImpl()) {
        self.networking = networking
    }
    
    func getPlace(city: String, street: String) async throws -> MSResponse {
        return try await networking.getPlace(city: city, street: street)
    }
}
