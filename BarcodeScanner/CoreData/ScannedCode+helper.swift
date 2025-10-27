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
        codeEntity.code = link
        try context.save()
    }
    
    static func saveBarcode(_ scannedCode: ScannedCode?, code: String, title: String, context: NSManagedObjectContext) throws {
        let codeEntity = ScannedCodeEntity(context: context)
        
        codeEntity.id = UUID()
        codeEntity.title = title
        codeEntity.scannedDate = Date()
        codeEntity.type = "barcode"
        codeEntity.code = code
        
        if let scannedCode {
            codeEntity.brand = scannedCode.brands
            codeEntity.title = scannedCode.productName
            codeEntity.nutriScore = scannedCode.nutriscoreGrade
            codeEntity.productName = scannedCode.productName
            if let ingredients = scannedCode.ingredients {
                codeEntity.ingredients = ingredients.compactMap {$0.text ?? nil}.joined(separator: "----")
            }
        }
        
        try context.save()
    }
    
    static func delete(at offsets: IndexSet, for items: [ScannedCodeEntity]) throws {
        if let first = items.first, let context = first.managedObjectContext {
            offsets.map { items[$0] }.forEach(context.delete)
            try context.saveContext()
        }
    }
    
    static func isCodeAlreadySaved(code: String, type: CodeType, context: NSManagedObjectContext) throws -> Bool {
        let request: NSFetchRequest<ScannedCodeEntity> = ScannedCodeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "code == %@ AND type == %@", code, type.rawValue)
        do {
            let scannedCode = try context.fetch(request).first
            if scannedCode != nil {
                return true
            } else {
                return false
            }
        } catch {
            throw URLError(.networkConnectionLost) // поменять
        }
    }
}
