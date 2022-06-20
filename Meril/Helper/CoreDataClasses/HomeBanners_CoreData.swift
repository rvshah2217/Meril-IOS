//
//  CoreDataVC.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 29/03/22.
//

import Foundation
import CoreData

class HomeBanners_CoreData {
    
    static let sharedInstance = HomeBanners_CoreData()
//    var container: NSPersistentContainer!
    let managedContext = appDelegate.persistentContainer.viewContext
    
    func saveBanners(schemeData: [UserTypesModel]) {
        //Update formdata on regular interval for example: update it if last added record was before 3 days
        let lastStoredFormData = fetchBannersDataByDate()
        if let lastStoredDate = lastStoredFormData?.creationDate, (Calendar.current.dateComponents([.day], from: lastStoredDate, to: Date()).day ?? 0) < 4 {
            return
        }
        
        do {
            let encodedData = try JSONEncoder().encode(schemeData)
            let jsonStr = String(data: encodedData, encoding: String.Encoding.utf8)
                        
            let entityFormData = NSEntityDescription.entity(forEntityName: "HomeBanners", in: managedContext)!
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
    func fetchBannersDataByDate() -> HomeBanners? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HomeBanners")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchRequest.fetchLimit = 1
        //            let predicate = NSPredicate(format: "(creationDate == %@)", Date() as! NSDate)
        //            fetchRequest.predicate = predicate
        do {
            let userTypesData = try managedContext.fetch(fetchRequest).first as? HomeBanners
            return userTypesData
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchBanners() -> [UserTypesModel]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HomeBanners")
//        fetchRequest.resultType = .dictionaryResultType
        do {
            guard let userTypesData = try managedContext.fetch(fetchRequest).first as? HomeBanners else {
                return nil
            }
            let jsonData = (userTypesData.responseStr ?? "").data(using: .utf8)!
            let userTypeObj = try JSONDecoder().decode([UserTypesModel].self, from: jsonData)
            return userTypeObj
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return nil
    }
    
}

