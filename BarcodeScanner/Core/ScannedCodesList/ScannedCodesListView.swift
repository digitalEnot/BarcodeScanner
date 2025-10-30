//
//  ScannedCodesListView.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 17.10.2025.
//

import SwiftUI
import CoreData
import AVFoundation

struct ScannedCodesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ScannedCodeEntity.title_, ascending: true)],
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
        .alert(vm.error?.title ?? "", isPresented: $vm.presentError, presenting: vm.error, actions: errorActions, message: errorMessage)
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
                vm.error = .cantDeleteCode
            }
        }
    }
    
    private func openScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: showScannerView = true
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            showScannerView = true
                        } else {
                            vm.error = .cameraDenied
                        }
                    }
                }
            default: vm.error = .cameraDenied
        }
    }
}

extension ScannedCodesListView {
    @ViewBuilder
    private func errorActions(error: ScannedCodesListError) -> some View {
        Button("Ок") {
            vm.presentError = false
        }
        
        if error == .cameraDenied {
            Button("Настройки") {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
        }
    }
    
    @ViewBuilder
    private func errorMessage(error: ScannedCodesListError) -> some View {
        Text(error.message)
    }
}

#Preview {
    ScannedCodesListView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
