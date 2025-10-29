//
//  ScannedCodesListViewModel.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 19.10.2025.
//

import Foundation
import Combine

class ScannedCodesListViewModel: ObservableObject {
    @Published var error: ScannedCodesListError?
    @Published var presentError: Bool = false
    var cancellables = Set<AnyCancellable>()
    
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
