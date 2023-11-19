//
//  LoadableContent.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 14/11/2023.
//

import SwiftUI
// TODO: FIX UPDATE VIEW
struct LoadableContent<Content: View, Model: BaseViewModel>: View {
    @ObservedObject var stateViewModel: Model
    var fullHeight: Bool = true
    
    @State private var content: Content
        
        init(stateViewModel: Model, fullHeight: Bool = true, @ViewBuilder content: @escaping () -> Content) {
            self.stateViewModel = stateViewModel
            self.fullHeight = fullHeight
            self._content = State(wrappedValue: content())
        }
    var body: some View {
        ZStack {
            if stateViewModel.isLoading {
                ProgressView()
            } else if let error = stateViewModel.apiErrorDescription,
                      stateViewModel.apiError {
                ErrorView(error: error)
            } else {
                content
            }
        }
        .frame(maxHeight: fullHeight ? .infinity : nil, alignment: .center)
    }
}

struct LoadableContent_Previews: PreviewProvider {
    static var previews: some View {
        LoadableContent(stateViewModel: AddNewEntryViewModel()) { }
    }
}
