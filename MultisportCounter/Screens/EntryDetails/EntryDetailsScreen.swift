//
//  EntryDetailsScreen.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 08/11/2023.
//

import SwiftUI

struct EntryDetailsScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var entry: Entry?
    
    var body: some View {
//        Text(viewModel.getFormattedDate(date: entry?.date, .birthDay))
        Text(entry?.msEntry?.name ?? "")
        Button("remove") {
           
            if let entry = entry {
                dismiss()
                viewModel.$entries.remove(entry)
            }
            
            
        }
    }
}

struct EntryDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailsScreen()
    }
}
