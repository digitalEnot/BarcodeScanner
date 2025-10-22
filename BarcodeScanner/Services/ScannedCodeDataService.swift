//
//  ScannedCodeDataService.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 21.10.2025.
//

import Foundation
import Combine

class ScannedCodeDataService {
    @Published var codeData: ScannedCode?
    var codeSubscription: AnyCancellable?
    
    init(scannedCode: String) {
        getCodeData(with: scannedCode)
        print(scannedCode)
    }
    
    func getCodeData(with code: String) {
        guard let url = URL(string: "https://world.openfoodfacts.net/api/v2/product/{\(code)}") else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "fields", value: "product_name,nutriscore_data,brands,ingredients"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        codeSubscription = NetworkManager.download(url: url)
            .decode(type: ScannedCodeItem.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (codeData) in
                self?.codeData = codeData.product
                self?.codeSubscription?.cancel()
            })
    }
}
