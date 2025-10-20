//
//  ScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 19.10.2025.
//

import Foundation
import Combine
import CoreGraphics

class ScannerViewModel: ObservableObject {
    @Published var rectOfInterest: CGRect? /*= CGRect(x: 100, y: 550, width: 100, height: 220)*/
}
