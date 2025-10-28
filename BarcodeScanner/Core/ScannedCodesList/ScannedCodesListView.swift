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
        sortDescriptors: [NSSortDescriptor(keyPath: \ScannedCodeEntity.scannedDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<ScannedCodeEntity>
    @State private var showScannerView = false
    @StateObject private var vm = ScannedCodesListViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if items.isEmpty {
                    contentUnavailable
                } else {
                    listOfCodes
                }
            }
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
    
    private var contentUnavailable: some View {
        ContentUnavailableView(
            "История сканов пуста",
            systemImage: "bookmark.slash",
            description: Text("Отканируйте свой первый код нажав на кнопку \(Image(systemName: "barcode.viewfinder"))")
        )
    }
    
    private var listOfCodes: some View {
        List {
            ForEach(items) { code in
                NavigationLink(destination: ScannedCodeDetailsView(scannedCode: code)) {
                    ScannedCodesRow(scannedCode: code)
                }
            }
            .onDelete(perform: deleteCodes)
        }
    }
    
    private func deleteCodes(offsets: IndexSet) {
        withAnimation {
            do {
                try ScannedCodeEntity.delete(at: offsets, for: Array(items))
            } catch {
                print("Возникла ошибка при удалении кода \(error)")
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
