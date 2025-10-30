//
//  EditCodeNameError.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 29.10.2025.
//


enum EditCodeNameError {
    case cantSaveCode
    case codeAlreadySaved
    case cantRetrieveCode
    case noInfoForCode
    case noInternetConnection
    case problemWithServer
    
    var title: String {
        switch self {
        case .cantSaveCode: "Не получилось сохранить"
        case .codeAlreadySaved: "Код уже сохранен"
        case .cantRetrieveCode: "Ошибка"
        case .noInfoForCode: "Внимание!"
        case .noInternetConnection: "Нет интернета"
        case .problemWithServer: "Ошибка подключения"
        }
    }
    
    var message: String {
        switch self {
        case .cantSaveCode: "При сохранении кода произошла ошибка. Попробуйте еще раз"
        case .codeAlreadySaved: "Этот код уже был отсканирован"
        case .cantRetrieveCode: "Не получилось проверить наличие кода среди уже сохраненных. Попробуйте еще раз"
        case .noInfoForCode: "В базе не найдена дополнительная информация для этого кода. Он будет сохранен без нее"
        case .noInternetConnection: "Проверьте интернет соединение и попробуйте еще раз"
        case .problemWithServer: "У нас возникли проблемы, скоро все починим"
        }
    }
}
