//
//  FormData+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 30/03/22.
//
//

import Foundation
import CoreData


extension FormData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormData> {
        return NSFetchRequest<FormData>(entityName: "FormData")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var responseStr: String?

}
