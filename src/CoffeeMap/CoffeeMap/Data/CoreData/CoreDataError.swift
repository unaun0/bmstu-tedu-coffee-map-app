//
//  CoreDataError.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 22.05.2025.
//

import CoreData

enum CDError: Error {
    case persistentStoreLoadFailed(underlyingError: NSError)
    case saveFailed(underlyingError: NSError)
    case invalidUUID
    case objectNotFound
}

extension CDError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .persistentStoreLoadFailed(let underlyingError):
            return "Ошибка загрузки persistent store: \(underlyingError.localizedDescription)"
        case .saveFailed(let underlyingError):
            return "Ошибка сохранения контекста: \(underlyingError.localizedDescription)"
        case .invalidUUID:
            return "Некорректный UUID."
        case .objectNotFound:
            return "Объект не найден в Core Data."
        }
    }
}
