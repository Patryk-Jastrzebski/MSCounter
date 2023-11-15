//
//  ErrorView.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 14/11/2023.
//

import SwiftUI

struct ErrorView: View {
    var error: String = "Wystąpił błąd"
    var action: SimpleAction?
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.red)
            Text(error)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .onTapGesture {
            action?()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
