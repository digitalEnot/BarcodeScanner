//
//  ScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 19.10.2025.
//

import Foundation
import Combine

enum ScannerError {
    case cantToggleFlashlight
    case cameraProblems
    
    var title: String {
        switch self {
        case .cantToggleFlashlight: "Проблемы с фонариком"
        case .cameraProblems: "Проблемы с камерой"
        }
    }
    
    var message: String {
        switch self {
        case .cantToggleFlashlight: "Не получилось переключить фонарик. Попробуйте позже"
        case .cameraProblems: "Не получилось включить камеру. Попробуйте еще раз"
        }
    }
}

class ScannerViewModel: ObservableObject {
    @Published var rectOfInterest: CGRect?
    @Published var isFlashOn = false
    @Published var error: ScannerError?
    @Published var scannedCode = ""
    @Published var codeType: CodeType?
    @Published var presentError = false
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        subscribeToError()
    }
    
    private func subscribeToError() {
        $error
            .dropFirst()
            .sink { [weak self] error in
                guard let _ = error, let self else { return }
                presentError = true
            }
            .store(in: &cancellables)
    }
}
