//
//  EditCodeNameView.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 21.10.2025.
//

import SwiftUI

struct EditCodeNameLoadingView: View {
    private let scannedCode: String
    private let dismiss: DismissAction
    private let codeType: CodeType?
    
    init(scannedCode: String, dismiss: DismissAction, codeType: CodeType?) {
        self.scannedCode = scannedCode
        self.dismiss = dismiss
        self.codeType = codeType
    }
    
    var body: some View {
        ZStack {
            if let codeType {
                EditCodeNameView(scannedCode: scannedCode, dismiss: dismiss, codeType: codeType)
            }
        }
    }
}

struct EditCodeNameView: View {
    
    @StateObject var vm: EditCodeNameViewModel
    @State private var fontSize: CGFloat = 24
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.managedObjectContext) var context
    private let dismiss: DismissAction
    
    init(scannedCode: String, dismiss: DismissAction, codeType: CodeType) {
        self._vm = StateObject(wrappedValue: EditCodeNameViewModel(scannedCode: scannedCode, codeType: codeType))
        self.dismiss = dismiss
    }
    
    var body: some View {
        if !vm.showProgressView {
            VStack(spacing: 40) {
                Text("Введите название отсканированного кода:")
                    .font(.headline)
                
                TextField("Введите название для кода", text: $vm.title)
                    .textFieldStyle(UnderlinedTextFieldStyle(borderColor: isTextFieldFocused ? .blue : .gray))
                    .disableAutocorrection(true)
                    .font(.system(size: fontSize))
                    .frame(width: 200)
                    .focused($isTextFieldFocused)
                    .onChange(of: vm.title) { _, newValue in
                        withAnimation {
                            fontSize = vm.title.count == 0 ? 13 : vm.title.count > 15 ? 16 : 24
                        }
                    }
                
                Button {
                    saveScannedCode()
                } label: {
                    Text("Сохранить")
                        .foregroundColor(vm.title.isEmpty ? .secondary : Color.black)
                        .frame(width: 200)
                        .padding()
                        .background(vm.title.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(vm.title.isEmpty)
                
                Spacer()
            }
            .onAppear { fontSize = vm.title.count == 0 ? 13 : vm.title.count > 15 ? 16 : 24 }
            .alert(vm.error?.title ?? "", isPresented: $vm.presentError, presenting: vm.error, actions: errorActions, message: errorMessage)
        } else {
            ProgressView()
        }
    }
    
    private func saveScannedCode() {
        vm.saveScannedCode()
        dismiss()
    }
}

extension EditCodeNameView {
    @ViewBuilder
    private func errorActions(error: EditCodeNameError) -> some View {
        if error == .noInfoForCode {
            Button("Ок") {
                vm.dequeue()
            }
        } else if error == .problemWithServer || error == .noInternetConnection {
            Button("Отмена") {
                vm.dequeue()
            }
            Button("Повторить") {
                vm.dequeue()
                vm.processCodeType()
            }
        } else {
            Button("Ок") {
                vm.dequeue()
                dismiss()
            }
        }
    }
    
    @ViewBuilder
    private func errorMessage(error: EditCodeNameError) -> some View {
        Text(error.message)
    }
}
