//
//  NearEntryView.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 14/11/2023.
//

import SwiftUI

struct NearEntryView: View {
    var msObject: MSEntry
    
    // TODO: Clickable object with detailsView and Map using lat and lng for suggested objects
    var body: some View {
        if let name = msObject.name,
           let address = msObject.address,
           let city = msObject.city {
            entryInfoLabel("Nazwa: ", info: name)
            entryInfoLabel("Adres: ", info: address + " " + city)
        }
    }
    
    private func entryInfoLabel(_ header: String, info: String) -> some View {
        HStack {
            Text(header)
                .foregroundColor(.secondary)
            Text(info)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct NearEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NearEntryView(msObject: .mock)
    }
}
