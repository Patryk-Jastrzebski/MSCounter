//
//  ModalViewTopIndicator.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 14/11/2023.
//

import SwiftUI

struct ModalViewTopIndicator: View {
    var body: some View {
        Capsule()
            .frame(width: 60, height: 3, alignment: .center)
            .foregroundColor(.secondary)
            .padding(.top, 6)
    }
}

struct ModalViewTopIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ModalViewTopIndicator()
    }
}
