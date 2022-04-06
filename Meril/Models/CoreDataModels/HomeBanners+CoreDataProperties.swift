//
//  HomeBanners+CoreDataProperties.swift
//  
//
//  Created by Nidhi Suhagiya on 06/04/22.
//
//

import Foundation
import CoreData


extension HomeBanners {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HomeBanners> {
        return NSFetchRequest<HomeBanners>(entityName: "HomeBanners")
    }

    @NSManaged public var responseStr: String?
    @NSManaged public var creationDate: Date?

}
