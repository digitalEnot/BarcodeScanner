//
//  ScannedCodeDetailsView.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 26.10.2025.
//

import SwiftUI

struct ScannedCodeDetailsView: View {
    
    @State var height: CGFloat = 0
    let scannedCode: ScannedCodeEntity
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                switch type {
                case .qr:
                    Text("just qr")
                case .barcode:
                    scoreMark
                    productName
                    brand
                    ingredients
                    Spacer()
                    scannedDate
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.linear(duration: 0.5)) {
                height = 120
            }
        }
    }
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .short
        return formatter
    }
    
    private var type: CodeType {
        CodeType(rawValue: scannedCode.type ?? "") ?? .qr
    }
    
    private var scoreMark: some View {
        Text(scannedCode.nutriScore ?? "")
            .bold()
            .font(.system(size: 25))
            .background {
                VStack {
                    Spacer(minLength: 0)
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color(scannedCode.nutriScore ?? ""))
                        .frame(width: 80, height: height)
                }
                .frame(height: 120)
            }
            .safeAreaPadding()
            .padding(.vertical, 80)
    }
    
    private var productName: some View {
        Text(scannedCode.productName ?? "")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var brand: some View {
        Text(scannedCode.brand ?? "")
            .font(.subheadline)
            .foregroundStyle(Color.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
    }
    
    private var ingredients: some View {
        Text(scannedCode.ingredients ?? "")
    }
    
    private var scannedDate: some View {
        Text("Отсканирован: \(formatter.string(from: scannedCode.scannedDate ?? Date()))")
            .font(.system(size: 12))
            .foregroundStyle(Color.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
