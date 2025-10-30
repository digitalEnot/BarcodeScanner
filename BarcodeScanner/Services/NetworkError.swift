//
//  NetworkError.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 30.10.2025.
//


enum NetworkError: Error {
    case noInternetConnection
    case noData
    case serverError
}
