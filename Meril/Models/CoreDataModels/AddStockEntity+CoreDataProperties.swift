//
//  AddStockEntity+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 30/03/22.
//
//

import Foundation
import CoreData


extension AddStockEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddStockEntity> {
        return NSFetchRequest<AddStockEntity>(entityName: "AddStock")
    }

    @NSManaged public var barcodes: String?
    @NSManaged public var distributorId: Int16
    @NSManaged public var doctorId: Int16
    @NSManaged public var hospitalId: Int16
    @NSManaged public var salesPersonId: Int16
    @NSManaged public var stockId: String?

}
