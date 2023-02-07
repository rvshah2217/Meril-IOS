//
//  StoreFormData.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 30/03/22.
//

import Foundation
import CoreData

class StoreFormData {
    
    static let sharedInstance = StoreFormData()
    let managedContext = appDelegate.persistentContainer.viewContext
    
    func saveFormData(schemeData: SurgeryInventoryModel) {
        //Update formdata on regular interval for example: update it if last added record was before 3 days
        let lastStoredFormData = fetchFormDataByDate()
        
        do {
            let encodedData = try JSONEncoder().encode(schemeData)
            let jsonStr = String(data: encodedData, encoding: String.Encoding.utf8)
            
            let entityFormData = NSEntityDescription.entity(forEntityName: "FormData", in: managedContext)!
            //            If record exist then update it else insert it 
            if lastStoredFormData != nil {
                lastStoredFormData?.creationDate = Date()
                lastStoredFormData?.responseStr = jsonStr
            } else {
                let userTypes = NSManagedObject(entity: entityFormData, insertInto: managedContext)
                userTypes.setValue(jsonStr, forKey: "responseStr")
                userTypes.setValue(Date(), forKey: "creationDate")
            }
            try managedContext.save()
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to save FormData: \(error.localizedDescription)")
        }
    }
    
    //        Check Form data already exist or not
    func fetchFormDataByDate() -> FormData? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FormData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchRequest.fetchLimit = 1
        do {
            let userTypesData = try managedContext.fetch(fetchRequest).first as? FormData
            return userTypesData
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchFormData() -> SurgeryInventoryModel? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FormData")
        do {
            guard let userTypesData = try managedContext.fetch(fetchRequest).first as? FormData else {
                return nil
            }
            
            let jsonData = (userTypesData.responseStr ?? "").data(using: .utf8)!
            
            let userTypeObj = try JSONDecoder().decode(SurgeryInventoryModel.self, from: jsonData)            
            return userTypeObj
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return nil
    }
    
    
}
