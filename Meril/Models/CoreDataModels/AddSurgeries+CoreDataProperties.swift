//
//  AddSurgeries+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 04/04/22.
//
//

import Foundation
import CoreData


extension AddSurgeries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddSurgeries> {
        return NSFetchRequest<AddSurgeries>(entityName: "AddSurgeries")
    }

    @NSManaged public var addSurgeryStr: String?
    @NSManaged public var isSyncedWithServer: Bool
    @NSManaged public var creationDate: Date?
    @NSManaged public var surgeryId: String?

}
