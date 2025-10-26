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
    @Published var error: Error?
    @Published var showProgressView = true
    
    private let scannedCodeDataService = ScannedCodeDataService()
    private var cancellables = Set<AnyCancellable>()
    let scannedCode: String
    let codeType: CodeType?
    var scannedCodeData: ScannedCode?
    let context = PersistenceController.shared.container.viewContext
    
    init(scannedCode: String, codeType: CodeType?) {
        self.scannedCode = scannedCode
        self.codeType = codeType
        processCodeType(codeType: codeType)
        addSubscribers()
    }
    
    func saveScannedCode() {
        guard let codeType else {
            print("Произошла ошибка при сохранении кода") // заменить
            return
        }
        switch codeType {
        case .qr:
            do {
                try ScannedCodeEntity.saveQrCode(link: scannedCode, title: title, context: context)
            } catch {
                print("Произошла ошибка при сохранении кода \(error)") // заменить
            }
        case .barcode:
            do {
                try ScannedCodeEntity.saveBarcode(scannedCodeData, code: scannedCode, title: title, context: context)
            } catch {
                print("Произошла ошибка при сохранении кода \(error)") // заменить
            }
        }
    }
    
    private func checkIfCodeInDataBase() {
        guard let codeType else { return }
        do {
            let result = try ScannedCodeEntity.isCodeAlreadySaved(code: scannedCode, type: codeType, context: context)
            if result {
                error = URLError(.unknown) // замнить на код уже есть в базе данных
                print("уже есть") // убрать
            }
        } catch {
            self.error = error
        }
    }
    
    private func processCodeType(codeType: CodeType?) {
        guard let codeType else { return } // добавить ошибку
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
                scannedCodeData = returnedData
                title = returnedData?.productName ?? ""
                showProgressView = false
                checkIfCodeInDataBase()
            }
            .store(in: &cancellables)
        
        scannedCodeDataService.$error
            .dropFirst()
            .sink { [weak self] error in
                guard let self else { return }
                self.error = URLError(.unknown) // заменить
            }
            .store(in: &cancellables)
    }
}
