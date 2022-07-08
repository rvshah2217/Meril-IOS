//
//  SurgeryList_CoreData.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 04/04/22.
//

import Foundation
import CoreData

class SurgeryList_CoreData {
    
    static let sharedInstance = SurgeryList_CoreData()
    let managedContext = appDelegate.persistentContainer.viewContext
    
    func saveSurgeriesToCoreData(schemeData: [SurgeryData], isForceSave: Bool) {
        //Update formdata on regular interval for example: update it if last added record was before 3 days
        var lastStoredSurgeryData: SurgeryList?
        lastStoredSurgeryData = fetchSurgeryDataByDate()
//        if !isForceSave {
//            if let lastStoredDate = lastStoredSurgeryData?.creationDate, (Calendar.current.dateComponents([.day], from: lastStoredDate, to: Date()).hour ?? 0) < 1 {
//                return
//            }
//        }
        do {
            let encodedData = try JSONEncoder().encode(schemeData)
            let jsonStr = String(data: encodedData, encoding: String.Encoding.utf8)
            
            let entitySurgeryData = NSEntityDescription.entity(forEntityName: "SurgeryList", in: managedContext)!
            //            If record exist then update it else insert it
            if lastStoredSurgeryData != nil {
                lastStoredSurgeryData?.creationDate = Date()
                lastStoredSurgeryData?.responseStr = jsonStr
            } else {
                let userTypes = NSManagedObject(entity: entitySurgeryData, insertInto: managedContext)
                userTypes.setValue(jsonStr, forKey: "responseStr")
                userTypes.setValue(Date(), forKey: "creationDate")
            }
            try managedContext.save()
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to save FormData: \(error.localizedDescription)")
        }
    }
    
    //        Check Form data already exist or not
    func fetchSurgeryDataByDate() -> SurgeryList? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SurgeryList")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchRequest.fetchLimit = 1
        do {
            let userTypesData = try managedContext.fetch(fetchRequest).first as? SurgeryList
            GlobalFunctions.printToConsole(message: "json str:- \(userTypesData?.responseStr)")
            return userTypesData
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchSurgeryData() -> [SurgeryData]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SurgeryList")
        do {
            guard let surgeryData = try managedContext.fetch(fetchRequest).first as? SurgeryList else {
                return nil
            }
            GlobalFunctions.printToConsole(message: "json fetch fromdata str:- \(surgeryData.responseStr)")
            let jsonData = (surgeryData.responseStr ?? "").data(using: .utf8)!
            let userTypeObj = try JSONDecoder().decode([SurgeryData].self, from: jsonData)
            return userTypeObj
            //            GlobalFunctions.printToConsole(message: "Total fetch userTypes data: \(userTypesData.count)")
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return nil
    }
    
    
}
