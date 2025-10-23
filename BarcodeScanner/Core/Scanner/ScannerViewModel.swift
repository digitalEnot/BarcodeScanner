//
//  ScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 19.10.2025.
//

import Foundation
import Combine

class ScannerViewModel: ObservableObject {
    @Published var rectOfInterest: CGRect?
    @Published var isFlashOn = false
    @Published var error: Error?
    @Published var scannedCode = ""
    @Published var codeType: CodeType = .none
}
