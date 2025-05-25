//
//  CoffeeShopsAPIResponseDTO.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 21.05.2025.
//

struct CoffeeShopsAPIResponseDTO: Decodable {
    let id: String
    let name: String
    let description: String?
    let contacts: Contacts?
    let workingHours: WorkingHours?
    let rating: Double?
    let photos: [String]?
    let location: Location

    enum CodingKeys: String, CodingKey {
        case id, name, description, contacts
        case workingHours = "working_hours"
        case rating, photos, location
    }

    struct Contacts: Decodable {
        let phone: String?
        let website: String?
    }

    struct WorkingHours: Decodable {
        let startTime: String?
        let endTime: String?
        let workingDays: [String]?

        enum CodingKeys: String, CodingKey {
            case startTime = "start_time"
            case endTime = "end_time"
            case workingDays = "working_days"
        }
    }

    struct Location: Decodable {
        let latitude: Double
        let longitude: Double
        let address: String
    }
}

// MARK: - To Entity

extension CoffeeShopsAPIResponseDTO {
    func toEntity() -> CoffeeShopEntity {
        var workingHoursMap: [String: CoffeeShopEntity.WorkingTime] = [:]
        if let wh = workingHours, let days = wh.workingDays {
            for day in days {
                workingHoursMap[day] = CoffeeShopEntity.WorkingTime(
                    startTime: wh.startTime,
                    endTime: wh.endTime
                )
            }
        }

        return CoffeeShopEntity(
            id: id,
            name: name,
            address: location.address, description: description,
            phone: contacts?.phone,
            website: contacts?.website,
            rating: rating,
            workingHours: workingHoursMap,
            location: CoffeeShopEntity.Location(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            photos: (photos ?? []).map { (url: $0, data: nil) },
            distance: nil,
            isLiked: false
        )
    }
}
