//
//  ScannedCodeDetailsView.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 26.10.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ScannedCodeDetailsView: View {
    
    @State var height: CGFloat = 0
    @State var offsetOfAlert: CGFloat = 130
    @State var alertIsOnScreen = false
    let scannedCode: ScannedCodeEntity
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                switch type {
                case .qr:
                    HStack {
                        HStack {
                            linkForQr
                            Spacer()
                            copyButton
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        arrowButton
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    Spacer()
                    showSuccess
                    scannedDate
                case .barcode:
                    if scannedCode.productName != nil {
                        ScrollView {
                            scoreMark
                            productName
                            brand
                            ingredients
                        }
                        scannedDate
                    } else {
                      contentUnavailable
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: shareCode()) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .navigationTitle(scannedCode.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.linear(duration: 0.5)) {
                height = 120
            }
        }
    }
    
    private func shareCode() -> String {
        var text = ""
        if type == .barcode {
            text = "Продукт: \(scannedCode.productName ?? "Неизвестный")\n"
            if let brand = scannedCode.brand {
                text += "Бренд: \(brand)\n"
            }
            text += "Штрих-код: \(scannedCode.code)"
        } else {
            text = "QR-код: \(scannedCode.link ?? "-")"
        }
        
        return text
    }
    
    private var contentUnavailable: some View {
        ContentUnavailableView(
            "Нет информации",
            systemImage: "text.page.slash.fill",
            description: Text("В базе open food facts не было найдено информации по данному коду")
        )
    }
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .short
        return formatter
    }
    
    private var type: CodeType {
        CodeType(rawValue: scannedCode.type) ?? .qr
    }
    
    private var scoreMark: some View {
        Text(nutriScoreText)
            .bold()
            .font(.system(size: 25))
            .background {
                VStack {
                    Spacer(minLength: 0)
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color(nutriScoreColorName))
                        .frame(width: 80, height: height)
                }
                .frame(height: 120)
            }
            .safeAreaPadding()
            .padding(.vertical, 80)
    }
    
    private var nutriScoreText: String {
        if let score = scannedCode.nutriScore {
            return "abcde".contains(score) ? score : "?"
        } else {
            return "?"
        }
    }
    
    private var nutriScoreColorName: String {
        return nutriScoreText == "?" ? "noInfo" : nutriScoreText
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
    }
    
    @ViewBuilder
    private var ingredients: some View {
        if let ingr = scannedCode.ingredients {
            TagsView(tags: (ingr).components(separatedBy: ","))
        }
    }
    
    private var scannedDate: some View {
        Text("Отсканирован: \(formatter.string(from: scannedCode.scannedDate))")
            .font(.system(size: 12))
            .foregroundStyle(Color.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var linkForQr: some View {
        Text(scannedCode.link ?? "")
            .font(.body)
            .padding()
            .textSelection(.enabled)
    }
    
    private var arrowButton: some View {
        Button {
            if let url = URL(string: scannedCode.link ?? "") {
                UIApplication.shared.open(url)
            }
        } label: {
            Image(systemName: "arrow.right.circle.fill")
                .foregroundStyle(Color.blue)
                .font(.system(size: 35))
        }

    }
    
    private var copyButton: some View {
        Button {
            if alertIsOnScreen { return }
            alertIsOnScreen = true
            UIPasteboard.general.setValue(scannedCode.link ?? "", forPasteboardType: UTType.plainText.identifier)
            withAnimation(.easeOut(duration: 0.25)) {
                offsetOfAlert = -25
            }
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeIn(duration: 0.25)) {
                    offsetOfAlert = 130
                    alertIsOnScreen = false
                }
            }
        } label: {
            Image(systemName: "document.on.document")
                .foregroundStyle(Color.gray)
        }
    }
    
    private var showSuccess: some View {
        HStack(spacing: 10) {
            Text("Скопировано!")
                .font(.system(size: 17))
                .foregroundStyle(.black)
            Image(systemName: "checkmark.circle")
                .foregroundStyle(Color.green)
                .font(.system(size: 20))
        }
            .padding()
            .background {
                Capsule()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
            .offset(y: offsetOfAlert)
    }
}
