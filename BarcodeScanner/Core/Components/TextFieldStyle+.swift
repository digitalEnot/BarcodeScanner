//
//  TextFieldStyle+.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 22.10.2025.
//

import Foundation
import SwiftUI

struct UnderlinedTextFieldStyle: TextFieldStyle {
    let borderColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(spacing: 0) {
            configuration
                .padding(.vertical, 8)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(borderColor)
        }
    }
}
