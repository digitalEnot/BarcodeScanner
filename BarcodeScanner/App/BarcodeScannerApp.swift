//
//  BarcodeScannerApp.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 17.10.2025.
//

import SwiftUI
import CoreData

@main
struct BarcodeScannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ScannedCodesListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
