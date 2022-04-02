//
//  CoreDataVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 29/03/22.
//

import Foundation
import CoreData

class UserTypeCoreData {
    
    static let sharedInstance = UserTypeCoreData()
//    var container: NSPersistentContainer!
    let managedContext = appDelegate.persistentContainer.viewContext
    
    func saveData(userData: UserTypesModel) {
        if self.fetchUserTypesById(userId: userData.id!) > 0 {
            return
        }
//        let managedContext = appDelegate.persistentContainer.viewContext
        let entityUserTypes = NSEntityDescription.entity(forEntityName: "UserTypes", in: managedContext)!
        let userTypes = NSManagedObject(entity: entityUserTypes, insertInto: managedContext)
        userTypes.setValue(userData.id, forKey: "id")
        userTypes.setValue(userData.name, forKey: "name")
        
        do {
            try managedContext.save()
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to save userTypes: \(error.localizedDescription)")
        }
    }
    
    func fetchUserTypes() -> [UserTypesModel]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTypes")
        fetchRequest.resultType = .dictionaryResultType
        do {
            let userTypesData = try managedContext.fetch(fetchRequest)
            let jsonData = try JSONSerialization.data(withJSONObject: userTypesData, options: .prettyPrinted)
            let userTypeObj = try JSONDecoder().decode([UserTypesModel].self, from: jsonData)
            return userTypeObj
//            GlobalFunctions.printToConsole(message: "Total fetch userTypes data: \(userTypesData.count)")
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchUserTypesById(userId: Int) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTypes")
        let predicate = NSPredicate(format: "(id == %d)", userId)
        fetchRequest.predicate = predicate
        do {
            let userTypesData = try managedContext.fetch(fetchRequest)
            return userTypesData.count
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return 0
    }
}

//extension NSManagedObject {
//  func toJSON() -> String? {
//    let keys = Array(self.entity.attributesByName.keys)
//    let dict = self.dictionaryWithValues(forKeys: keys)
//    do {
//        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
//        let reqJSONStr = String(data: jsonData, encoding: .utf8)
//        return reqJSONStr
//    }
//    catch{}
//    return nil
//  }
