//
//  CameraVCRepresentable.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 20.10.2025.
//
import Foundation
import SwiftUI
import Combine

protocol CameraVCDelegate: AnyObject {
    func didFindCode(_ code: String, type: CodeType)
    func didEndWithError(_ error: Error)
    func didGetBounds(_ bounds: CGRect?)
    func turnOffFlash()
}

struct CameraVCRepresentable: UIViewControllerRepresentable {
    @Binding var isFlashOn: Bool
    @Binding var error: Error?
    @Binding var scannedCode: String
    @Binding var rectOfInterest: CGRect?
    @Binding var codeType: CodeType
    @Binding var path: NavigationPath
    let viewModel = ViewModel()
    
    func makeUIViewController(context: Context) -> CameraVC {
        CameraVC(delegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: CameraVC, context: Context) {
        // избегаем обновление фонарика лишний раз (например при получении ошибки или после прочтения кода)
        if viewModel.shouldUpdateView {
            uiViewController.setFlashlightTo(isFlashOn)
        } else {
            viewModel.shouldUpdateView = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(delegate: self)
    }
    
    final class Coordinator: NSObject, CameraVCDelegate {
        private let delegate: CameraVCRepresentable
        
        init(delegate: CameraVCRepresentable) {
            self.delegate = delegate
        }
        
        func didFindCode(_ code: String, type: CodeType) {
            delegate.viewModel.shouldUpdateView = false
            self.delegate.scannedCode = code
            self.delegate.codeType = type
            delegate.path.append("EditCodeName")
        }
        
        func didEndWithError(_ error: Error) {
            delegate.viewModel.shouldUpdateView = false
            self.delegate.error = error
        }
        
        func didGetBounds(_ bounds: CGRect?) {
            delegate.viewModel.shouldUpdateView = false
            self.delegate.rectOfInterest = bounds
        }
        
        func turnOffFlash() {
            delegate.viewModel.shouldUpdateView = false
            self.delegate.isFlashOn = false
        }
    }
    
    class ViewModel {
        var shouldUpdateView: Bool = true
    }
}
