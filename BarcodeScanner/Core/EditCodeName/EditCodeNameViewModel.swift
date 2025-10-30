//
//  EditCodeNameViewModel.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 21.10.2025.
//

import Foundation
import Combine
import CoreData

class EditCodeNameViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var error: EditCodeNameError?
    @Published var showProgressView = true
    @Published var presentError = false
    
    private var errorQueue: [EditCodeNameError] = []
    private let scannedCodeDataService = ScannedCodeDataService()
    private var cancellables = Set<AnyCancellable>()
    let scannedCode: String
    let codeType: CodeType
    var scannedCodeData: ScannedCode?
    let context = PersistenceController.shared.container.viewContext
    
    init(scannedCode: String, codeType: CodeType) {
        self.scannedCode = scannedCode
        self.codeType = codeType
        addSubscribers()
        checkIfCodeInDataBase()
        processCodeType(codeType: codeType)
    }
    
    private func enqueue(_ alert: EditCodeNameError) {
        errorQueue.append(alert)
        if errorQueue.count == 1 {
            error = alert
        }
    }
    
    func dequeue() {
        if !errorQueue.isEmpty {
            errorQueue.removeFirst()
            if !errorQueue.isEmpty {
                error = errorQueue.removeFirst()
            }
        }
    }
    
    func saveScannedCode() {
        switch codeType {
        case .qr:
            do {
                try ScannedCodeEntity.saveQrCode(link: scannedCode, title: title, context: context)
            } catch {
                enqueue(.cantSaveCode)
            }
        case .barcode:
            do {
                try ScannedCodeEntity.saveBarcode(scannedCodeData, code: scannedCode, title: title, context: context)
            } catch {
                enqueue(.cantSaveCode)
            }
        }
    }
    
    private func checkIfCodeInDataBase() {
        do {
            let result = try ScannedCodeEntity.isCodeAlreadySaved(code: scannedCode, type: codeType, context: context)
            if result {
                enqueue(.codeAlreadySaved)
            }
        } catch {
            enqueue(.cantRetrieveCode)
        }
    }
    
    private func processCodeType(codeType: CodeType) {
        switch codeType {
        case .qr:
            showProgressView = false
        case .barcode:
            scannedCodeDataService.getCodeData(with: scannedCode)
        }
    }
    
    private func addSubscribers() {
        scannedCodeDataService.$codeData
            .dropFirst()
            .sink { [weak self] returnedData in
                guard let self else { return }
                guard let returnedData else {
                    showProgressView = false
                    enqueue(.noInfoForCode)
                    return
                }
                scannedCodeData = returnedData
                title = returnedData.productName ?? ""
                showProgressView = false
            }
            .store(in: &cancellables)
        
        $error
            .dropFirst()
            .sink { [weak self] error in
                guard let _ = error, let self else { return }
                presentError = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
                    self?.presentError = true
                }
            }
            .store(in: &cancellables)
    }
}
