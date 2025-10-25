//
//  ScannedCodesRow.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 23.10.2025.
//

import SwiftUI

struct ScannedCodesRow: View {
    let scannedCode: ScannedCodeEntity
        
    var body: some View {
        HStack {
            VStack {
                Text(title)
                
                if let underTitle = underTitle {
                    Text(underTitle)
                }
            }
            
            Spacer()
            
            Text(typeText)
        }
    }
    
    private var title: String {
        return scannedCode.title ?? "Неизвестный код"
    }
    
    private var underTitle: String? {
        switch type {
        case .barcode:
            return scannedCode.brand
        case .qr:
            return scannedCode.link
        }
    }
    
    private var typeText: String {
        scannedCode.type ?? ""
    }
    
    private var type: CodeType {
        CodeType(rawValue: typeText) ?? .qr
    }
}
