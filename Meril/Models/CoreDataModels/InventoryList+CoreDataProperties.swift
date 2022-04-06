//
//  InventoryList+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 06/04/22.
//
//

import Foundation
import CoreData


extension InventoryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InventoryList> {
        return NSFetchRequest<InventoryList>(entityName: "InventoryList")
    }

    @NSManaged public var responseStr: String?
    @NSManaged public var creationDate: Date?

}
