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
    let ingredients: [Ingredients]?
    let nutriscoreGrade: String?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands, ingredients
        case nutriscoreGrade = "nutriscore_grade"
    }
}

struct Ingredients: Decodable {
    let text: String?
}

enum CodeType: String {
    case qr = "qr"
    case barcode = "barcode"
}
