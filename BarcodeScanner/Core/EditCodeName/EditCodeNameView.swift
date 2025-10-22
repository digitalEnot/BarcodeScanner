//
//  EditCodeNameView.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 21.10.2025.
//

import SwiftUI

struct EditCodeNameView: View {
    
    @StateObject var vm: EditCodeNameViewModel
    @State private var fontSize: CGFloat = 24
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.managedObjectContext) var context
    private var dismiss: DismissAction
    
    init(scannedCode: String, dismiss: DismissAction) {
        self._vm = StateObject(wrappedValue: EditCodeNameViewModel(scannedCode: scannedCode))
        self.dismiss = dismiss
    }
    
    var body: some View {
        if let _ = vm.scannedCodeData {
            VStack(spacing: 40) {
                Text("Введите название отсканированного кода:")
                    .font(.headline)
                
                TextField("", text: $vm.title)
                    .textFieldStyle(UnderlinedTextFieldStyle(borderColor: isTextFieldFocused ? .blue : .gray))
                    .disableAutocorrection(true)
                    .font(.system(size: fontSize))
                    .frame(width: 200)
                    .focused($isTextFieldFocused)
                    .onChange(of: vm.title) { _, newValue in
                        withAnimation {
                            fontSize = newValue.count > 15 ? 16 : 24
                        }
                    }
                
                Button(action: dismiss.callAsFunction) {
                    Text("Готово!")
                        .foregroundColor(.black)
                        .frame(width: 200)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .onAppear { fontSize = vm.title.count > 15 ? 16 : 24 }
        } else {
            ProgressView()
        }
    }
}
