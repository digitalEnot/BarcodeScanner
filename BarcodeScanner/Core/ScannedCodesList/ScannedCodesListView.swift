//
//  ScannedCodesListView.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 17.10.2025.
//

import SwiftUI
import CoreData

struct ScannedCodesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ScannedCode.scannedDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<ScannedCode>
    @State private var showScannerView = false
    @StateObject private var vm = ScannedCodesListViewModel()

    var body: some View {
        NavigationStack {
            Text("hello world")
            .navigationTitle("ScannedCodes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: openScanner) {
                        Label("", systemImage: "barcode.viewfinder")
                    }
                }
            }
            .sheet(isPresented: $showScannerView) {
                ScannerView()
            }
        }
    }
    
    private func openScanner() {
        showScannerView = true
    }
}

#Preview {
    ScannedCodesListView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
