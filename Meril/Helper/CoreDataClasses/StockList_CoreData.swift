//
//  StockList_CoreData.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 06/04/22.
//

import CoreData

class StockList_CoreData {
    
    static let sharedInstance = StockList_CoreData()
    let managedContext = appDelegate.persistentContainer.viewContext
    
    func saveStocksToCoreData(schemeData: [SurgeryData], isForceSave: Bool) {
        //Update formdata on regular interval for example: update it if last added record was before 3 days
        var lastStoredSurgeryData: InventoryList?
        lastStoredSurgeryData = fetchStocksDataByDate()
        if !isForceSave {
            if let lastStoredDate = lastStoredSurgeryData?.creationDate, (Calendar.current.dateComponents([.day], from: lastStoredDate, to: Date()).day ?? 0) < 4 {
                return
            }
        }
        do {
            let encodedData = try JSONEncoder().encode(schemeData)
            let jsonStr = String(data: encodedData, encoding: String.Encoding.utf8)
            
            let entitySurgeryData = NSEntityDescription.entity(forEntityName: "InventoryList", in: managedContext)!
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
    func fetchStocksDataByDate() -> InventoryList? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InventoryList")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchRequest.fetchLimit = 1
        do {
            let userTypesData = try managedContext.fetch(fetchRequest).first as? InventoryList
            GlobalFunctions.printToConsole(message: "fetchStocksDataByDate:- \(userTypesData?.responseStr)")
            return userTypesData
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchStocksData() -> [SurgeryData]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InventoryList")
        do {
            guard let surgeryData = try managedContext.fetch(fetchRequest).first as? InventoryList else {
                return nil
            }
            GlobalFunctions.printToConsole(message: "json fetch stock data str:- \(surgeryData.responseStr)")
            let jsonData = (surgeryData.responseStr ?? "").data(using: .utf8)!
            let userTypeObj = try JSONDecoder().decode([SurgeryData].self, from: jsonData)
            return userTypeObj
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to stock data records: \(error.localizedDescription)")
        }
        return nil
    }

}
