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
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badURL)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished: break
            case .failure(let error): print("произошла ошибка при получение информации о просканированном коде. \(error)") // заменить
        }
    }
}
