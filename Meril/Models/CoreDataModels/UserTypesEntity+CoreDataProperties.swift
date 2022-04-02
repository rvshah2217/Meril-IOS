//
//  UserTypesEntity+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 30/03/22.
//
//

import Foundation
import CoreData


extension UserTypesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserTypesEntity> {
        return NSFetchRequest<UserTypesEntity>(entityName: "UserTypes")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}
