//
//  Item+CoreDataProperties.swift
//  
//
//  Created by miyamotokenshin on R7/11/14.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var text: String?

}

extension Item : Identifiable {

}
