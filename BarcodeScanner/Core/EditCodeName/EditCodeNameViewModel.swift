//
//  EditCodeNameViewModel.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 21.10.2025.
//

import Foundation
import Combine

class EditCodeNameViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var error: Error?
    @Published var showProgressView = true
    
    private let scannedCodeDataService = ScannedCodeDataService()
    private var cancellables = Set<AnyCancellable>()
    let scannedCode: String
    let codeType: CodeType?
    var scannedCodeData: ScannedCode?
    
    init(scannedCode: String, codeType: CodeType?) {
        self.scannedCode = scannedCode
        self.codeType = codeType
        processCodeType(codeType: codeType)
        addSubscribers()
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
