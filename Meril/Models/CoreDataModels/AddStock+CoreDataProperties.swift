//
//  AddStock+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 06/04/22.
//
//

import Foundation
import CoreData


extension AddStock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddStock> {
        return NSFetchRequest<AddStock>(entityName: "AddStock")
    }

    @NSManaged public var addStockStr: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var isSyncedWithServer: Bool
    @NSManaged public var stockId: String?

}
