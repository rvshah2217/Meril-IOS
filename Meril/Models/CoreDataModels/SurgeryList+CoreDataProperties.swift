//
//  SurgeryList+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 04/04/22.
//
//

import Foundation
import CoreData


extension SurgeryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SurgeryList> {
        return NSFetchRequest<SurgeryList>(entityName: "SurgeryList")
    }

    @NSManaged public var responseStr: String?
    @NSManaged public var creationDate: Date?

}
