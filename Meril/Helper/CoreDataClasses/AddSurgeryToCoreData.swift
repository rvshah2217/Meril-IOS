//
//  AddSurgeryToCoreData.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 31/03/22.
//

import Foundation
import CoreData

class AddSurgeryToCoreData {
    
    static let sharedInstance = AddSurgeryToCoreData()
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    func saveSurgeryData(surgeryData: AddSurgeryRequestModel) {
        
        do {
            let encodedData = try JSONEncoder().encode(surgeryData)
            let jsonStr = String(data: encodedData, encoding: String.Encoding.utf8)
            
            let entityFormData = NSEntityDescription.entity(forEntityName: "FormData", in: managedContext)!
           
            let surgeryObj = NSManagedObject(entity: entityFormData, insertInto: managedContext)
            surgeryObj.setValue(jsonStr, forKey: "addSurgeryStr")
            surgeryObj.setValue(Date(), forKey: "creationDate")
            surgeryObj.setValue(false, forKey: "isSyncedWithServer")
            
            try managedContext.save()
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to save FormData: \(error.localizedDescription)")
        }
    }
    
    func fetchSurgeries() -> [AddSurgeryRequestModel]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddSurgery")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.predicate = NSPredicate(format: "isSyncedWithServer == %@", false)
        do {
            let userTypesData = try managedContext.fetch(fetchRequest)
            let jsonData = try JSONSerialization.data(withJSONObject: userTypesData, options: .prettyPrinted)
            let userTypeObj = try JSONDecoder().decode([AddSurgeryRequestModel].self, from: jsonData)
            return userTypeObj
//            GlobalFunctions.printToConsole(message: "Total fetch userTypes data: \(userTypesData.count)")
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return nil
    }
    
    func updateSurgeryStatus(surgeryId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddSurgery")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.predicate = NSPredicate(format: "surgeryId == %@", surgeryId)
        do {
            let sergeryData = try managedContext.fetch(fetchRequest).first as! AddSurgeryEntity
            sergeryData.isSyncedWithServer = true
            try managedContext.save()
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
    }
    
    func deleteSergeryBySurgeryId(surgeryId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddSurgery")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.predicate = NSPredicate(format: "surgeryId == %@", surgeryId)
        do {
            let surgeryData = try managedContext.fetch(fetchRequest)  as! [NSManagedObject]
            for surgery in surgeryData {
                managedContext.delete(surgery)
            }
            try managedContext.save()
            GlobalFunctions.printToConsole(message: "Item deleted successfully.")
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
    }
}

