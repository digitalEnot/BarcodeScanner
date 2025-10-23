//
//  ScannedCode.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 21.10.2025.
//

import Foundation

struct ScannedCodeItem: Decodable {
    let product: ScannedCode?
}

struct ScannedCode: Decodable {
    let id = UUID()
    let productName: String?
    let brands: String?
    let ingredientsText: String?
    let nutriscoreGrade: String?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case ingredientsText = "ingredients_text"
        case nutriscoreGrade = "nutriscore_grade"
    }
}

enum CodeType: String {
    case qr = "qr"
    case barcode = "barcode"
    case none
}
