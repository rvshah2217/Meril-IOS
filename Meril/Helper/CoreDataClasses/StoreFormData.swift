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
        if let lastStoredDate = lastStoredFormData?.creationDate, (Calendar.current.dateComponents([.day], from: lastStoredDate, to: Date()).day ?? 0) < 4 {
            return
        }
        
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
        //            let predicate = NSPredicate(format: "(creationDate == %@)", Date() as! NSDate)
        //            fetchRequest.predicate = predicate
        do {
            let userTypesData = try managedContext.fetch(fetchRequest).first as? FormData
            GlobalFunctions.printToConsole(message: "json str:- \(userTypesData?.responseStr)")
            return userTypesData
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchFormData() -> SurgeryInventoryModel? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FormData")
//        fetchRequest.resultType = .dictionaryResultType
        do {
            guard let userTypesData = try managedContext.fetch(fetchRequest).first as? FormData else {
                return nil
            }
            GlobalFunctions.printToConsole(message: "json fetch fromdata str:- \(userTypesData.responseStr)")
            let jsonData = (userTypesData.responseStr ?? "").data(using: .utf8)!//try JSONEncoder().encode(userTypesData.responseStr!)

            //JSONSerialization.data(withJSONObject: userTypesData.responseStr, options: .prettyPrinted)
            
            //            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            let userTypeObj = try JSONDecoder().decode(SurgeryInventoryModel.self, from: jsonData)            
            return userTypeObj
            //            GlobalFunctions.printToConsole(message: "Total fetch userTypes data: \(userTypesData.count)")
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return nil
    }
    
    
}
