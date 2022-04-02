//
//  AddSurgeryEntity+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 30/03/22.
//
//

import Foundation
import CoreData


extension AddSurgeryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddSurgeryEntity> {
        return NSFetchRequest<AddSurgeryEntity>(entityName: "AddSurgery")
    }

    @NSManaged public var age: Int32
    @NSManaged public var barcodes: String?
    @NSManaged public var cityId: Int16
    @NSManaged public var distributorId: Int16
    @NSManaged public var doctorId: Int16
    @NSManaged public var hospitalId: Int16
    @NSManaged public var ipCode: String?
    @NSManaged public var patientMobile: String?
    @NSManaged public var patientName: String?
    @NSManaged public var schemeId: Int16
    @NSManaged public var surgeryId: String?
    @NSManaged public var udtId: Int16

}
