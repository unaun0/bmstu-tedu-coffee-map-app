//
//  CoreDataCoffeeShopRepository.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 25.05.2025.
//

import CoreData
import Foundation

final class CDCoffeeShopRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CDStack.shared.context) {
        self.context = context
    }
}

// MARK: - CoffeeShopRepositoryInput

extension CDCoffeeShopRepository: CoffeeShopRepositoryInput {
    func fetchAll() throws -> [CoffeeShopRepositoryDTO] {
        let request: NSFetchRequest<CDCoffeeShop> = CDCoffeeShop.fetchRequest()
        let cdShops = try context.fetch(request)
        
        return cdShops.compactMap { toDTO(cdShop: $0) }
    }
    
    func save(_ shop: CoffeeShopRepositoryDTO) throws {
        guard let uuid = UUID(uuidString: shop.id) else {
            throw CDError.invalidUUID
        }
        
        let request: NSFetchRequest<CDCoffeeShop> = CDCoffeeShop.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            uuid as CVarArg
        )
        let cdShop: CDCoffeeShop
        if let existing = try context.fetch(request).first {
            cdShop = existing
        } else {
            cdShop = CDCoffeeShop(context: context)
        }
        fromDTO(cdShop: cdShop, from: shop)
        do {
            try context.save()
        } catch let error as NSError {
            throw CDError.saveFailed(underlyingError: error)
        }
    }

    func delete(_ shop: CoffeeShopRepositoryDTO) throws {
        guard let uuid = UUID(uuidString: shop.id) else {
            throw CDError.invalidUUID
        }
        let request: NSFetchRequest<CDCoffeeShop> = CDCoffeeShop.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            uuid as CVarArg
        )
        let cdShop = try context.fetch(request).first
        guard let objectToDelete = cdShop else {
            throw CDError.objectNotFound
        }
        
        context.delete(objectToDelete)
        
        do {
            try context.save()
        } catch let error as NSError {
            throw CDError.saveFailed(underlyingError: error)
        }
    }

    func find(by id: String) throws -> CoffeeShopRepositoryDTO? {
        guard let uuid = UUID(uuidString: id) else {
            throw CDError.invalidUUID
        }
        let request: NSFetchRequest<CDCoffeeShop> = CDCoffeeShop.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            uuid as CVarArg
        )
        guard let cdShop = try context.fetch(request).first else { return nil }
        
        return toDTO(cdShop: cdShop)
    }
}

private extension CDCoffeeShopRepository {
    func toDTO(cdShop: CDCoffeeShop) -> CoffeeShopRepositoryDTO? {
        guard let uuid = cdShop.id else { return nil }
        return CoffeeShopRepositoryDTO(
            id: uuid.uuidString,
            createdAt: cdShop.createdAt
        )
    }
    
    func fromDTO(cdShop: CDCoffeeShop, from dto: CoffeeShopRepositoryDTO) {
        cdShop.id = UUID(uuidString: dto.id)
        cdShop.createdAt = dto.createdAt ?? Date()
    }
}
