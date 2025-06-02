//
//  ErrorViewModel.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 02.06.2025.
//

struct ErrorViewModel {
    enum ErrorType {
        case network
        case location
        case generic
    }
    
    let type: ErrorType
    let title: String
    let message: String
    let canRetry: Bool
}

struct ErrorMapper {
    static func map(_ error: Error) -> ErrorViewModel {
        switch error {
        case let error as ImageLoaderError:
            return mapImageLoaderError(error)
        case let error as NetworkClientError:
            return mapNetworkClientError(error)
        case let error as LocationError:
            return mapLocationError(error)
        default:
            return ErrorViewModel(
                type: .generic,
                title: "Что-то пошло не так",
                message: error.localizedDescription,
                canRetry: false
            )
        }
    }

    private static func mapImageLoaderError(_ error: ImageLoaderError) -> ErrorViewModel {
        return ErrorViewModel(
            type: .generic,
            title: "Ошибка изображения",
            message: "Не удалось загрузить изображение.",
            canRetry: false
        )
    }

    private static func mapNetworkClientError(_ error: NetworkClientError) -> ErrorViewModel {
        switch error {
        case .networkError(let underlying):
            return ErrorViewModel(
                type: .network,
                title: "Сетевая ошибка",
                message: underlying.localizedDescription,
                canRetry: true
            )
        case .decodingError:
            return ErrorViewModel(
                type: .generic,
                title: "Ошибка данных",
                message: "Не удалось обработать полученные данные.",
                canRetry: false
            )
        }
    }

    private static func mapLocationError(_ error: LocationError) -> ErrorViewModel {
        switch error {
        case .accessDenied:
            return ErrorViewModel(
                type: .location,
                title: "Доступ к геолокации запрещён",
                message: "Разрешите доступ к местоположению в настройках.",
                canRetry: false
            )
        case .unableToGetLocation:
            return ErrorViewModel(
                type: .location,
                title: "Геолокация недоступна",
                message: "Не удалось определить ваше местоположение.",
                canRetry: true
            )
        }
    }
}
