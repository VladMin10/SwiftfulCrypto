//
//  XMarkButton.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 26.03.2024.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationmode
    
    var body: some View {
        Button(action: {presentationmode.wrappedValue.dismiss()}, label: {
            Image(systemName: "xmark")
                .font(.headline)
})
    }
}

#Preview {
    XMarkButton()
}
