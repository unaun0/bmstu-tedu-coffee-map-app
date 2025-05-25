//
//  CoffeeShop+CoreDataProperties.swift
//  
//
//  Created by Цховребова Яна on 22.05.2025.
//
//

import Foundation
import CoreData

extension CDCoffeeShop {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCoffeeShop> {
        return NSFetchRequest<CDCoffeeShop>(entityName: "CDCoffeeShop")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?
}
