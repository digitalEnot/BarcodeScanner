//
//  NetworkManager.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 21.10.2025.
//

import Foundation
import Combine

class NetworkManager {
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponce(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponce(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else { throw URLError(.badServerResponse)}
        
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            if response.statusCode == 404 {
                throw URLError(.cannotDecodeRawData)
            } else {
                throw URLError(.badServerResponse)
            }
        }
        return output.data
    }
}
