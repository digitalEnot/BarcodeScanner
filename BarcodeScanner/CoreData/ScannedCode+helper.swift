//
//  ScannedCode+helper.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 19.10.2025.
//

import Foundation
import CoreData

extension ScannedCodeEntity {
    static func saveQrCode(link: String, title: String, context: NSManagedObjectContext) throws {
        let codeEntity = ScannedCodeEntity(context: context)
        codeEntity.id = UUID()
        codeEntity.title = title
        codeEntity.scannedDate = Date()
        codeEntity.link = link
        codeEntity.type = "qr"
        
        try context.save()
    }
    
    static func saveBarcode(_ scannedCode: ScannedCode?, title: String, context: NSManagedObjectContext) throws {
        let codeEntity = ScannedCodeEntity(context: context)
        
        if let scannedCode {
            codeEntity.id = UUID()
            codeEntity.title = title
            codeEntity.scannedDate = Date()
            codeEntity.type = "barcode"
            codeEntity.brand = scannedCode.brands
            codeEntity.title = scannedCode.productName
            codeEntity.nutriScore = scannedCode.nutriscoreGrade
        } else {
            codeEntity.id = UUID()
            codeEntity.title = title
            codeEntity.scannedDate = Date()
            codeEntity.type = "barcode"
        }
        
        try context.save()
    }
    
    static func delete(at offsets: IndexSet, for items: [ScannedCodeEntity]) throws {
        if let first = items.first, let context = first.managedObjectContext {
            offsets.map { items[$0] }.forEach(context.delete)
            try context.saveContext()
        }
    }
}
