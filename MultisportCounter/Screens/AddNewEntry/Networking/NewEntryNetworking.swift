//
//  NewEntryNetworking.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 15/11/2023.
//

import Foundation

protocol NewEntryNetworking {
    func getPlace(city: String, street: String) async throws -> MSResponse
}

final class NewEntryNetworkingImpl: BaseNetworking, NewEntryNetworking {
    func getPlace(city: String, street: String) async throws -> MSResponse {
        let request = HttpRequest(url: baseUrl + "/bounds/matching/40/20/20/20",
                                  method: .get,
                                  parameters: MSEntryRequest(city: city, street: street))
        return try await perform(request)
    }
}
