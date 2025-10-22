//
//  EditCodeNameViewModel.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 21.10.2025.
//

import Foundation
import Combine

class EditCodeNameViewModel: ObservableObject {
    @Published var scannedCodeData: ScannedCode?
    @Published var title: String = ""
    
    private let scannedCodeDataService: ScannedCodeDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(scannedCode: String) {
        self.scannedCodeDataService = ScannedCodeDataService(scannedCode: scannedCode)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        scannedCodeDataService.$codeData
            .sink { [weak self] returnedData in
                self?.scannedCodeData = returnedData
                self?.title = returnedData?.productName ?? ""
            }
            .store(in: &cancellables)
    }
}
