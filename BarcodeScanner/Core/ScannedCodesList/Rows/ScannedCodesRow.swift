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
            VStack(alignment: .leading) {
                Text(scannedCode.title)
                    .font(.headline)
                    .lineLimit(1)
                
                if let underTitle = underTitle {
                    Text(underTitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: typeImage)
                .font(.system(size: 20))
        }
    }
    
    private var underTitle: String? {
        switch type {
        case .barcode:
            return scannedCode.brand
        case .qr:
            return scannedCode.link
        }
    }
    
    private var typeImage: String {
        switch type {
        case .barcode: "barcode"
        case .qr: "qrcode"
        }
    }
    
    private var type: CodeType {
        CodeType(rawValue: scannedCode.type) ?? .qr
    }
}
