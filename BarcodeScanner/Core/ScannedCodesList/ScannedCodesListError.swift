//
//  ScannedCodesListError.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 29.10.2025.
//


enum ScannedCodesListError {
    case cameraDenied
    case cantDeleteCode
    
    var title: String {
        switch self {
        case .cameraDenied: "Нет доступа к камере"
        case .cantDeleteCode: "Не получилось удалить"
        }
    }
    
    var message: String {
        switch self {
        case .cameraDenied: "Разрешите доступ к камере для сканирования кодов"
        case .cantDeleteCode: "При удалении кода произошла ошибка. Попробуйте позже"
        }
    }
}