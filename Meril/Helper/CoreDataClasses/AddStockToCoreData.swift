//
//  AddStockToCoreData.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 06/04/22.
//

import CoreData

class AddStockToCoreData {
    
    static let sharedInstance = AddStockToCoreData()
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    //    #MARK: Save inventory data
    func saveStockData(stockData: AddSurgeryRequestModel) {
        
        do {
            let encodedData = try JSONEncoder().encode(stockData)
            let jsonStr = String(data: encodedData, encoding: String.Encoding.utf8)
            
            let entityFormData = NSEntityDescription.entity(forEntityName: "AddStock", in: managedContext)!
            
            let surgeryObj = NSManagedObject(entity: entityFormData, insertInto: managedContext)
            surgeryObj.setValue(jsonStr, forKey: "addStockStr")
            surgeryObj.setValue(Date(), forKey: "creationDate")
            surgeryObj.setValue(false, forKey: "isSyncedWithServer")
            surgeryObj.setValue(stockData.stockId, forKey: "stockId")
            
            try managedContext.save()
        } catch {
            //GlobalFunctions.printToConsole(message: "Unable to save stock data: \(error.localizedDescription)")
        }
    }
    
    //    #MARK: Fetch inventory data
    func fetchStocks() -> [SurgeryData]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddStock")
        fetchRequest.predicate = NSPredicate(format: "isSyncedWithServer == %@", NSNumber(value: false))
        do {
            let surgeryTypesData = try managedContext.fetch(fetchRequest) as? [AddStock]
            var addedSurgeryArr: [SurgeryData] = []
            for surgery in surgeryTypesData ?? [] {
                //GlobalFunctions.printToConsole(message: "stock obj: \(surgery.isEqual(AddSurgeries.self))")
                
                let jsonData = (surgery.addStockStr ?? "").data(using: .utf8)!
                var surgeryObj = try JSONDecoder().decode(AddSurgeryRequestModel.self, from: jsonData)
                
                //                Convert barcode array
                let barcodeJsonData = (surgeryObj.barcodes ?? "").data(using: .utf8)!
                let barcodeObj = try JSONDecoder().decode([BarCodeModel].self, from: barcodeJsonData)
                surgeryObj.coreDataBarcodes = barcodeObj
                
                //                Convert manual entry array
                let manualBarcodeJsonData = (surgeryObj.manualEntry ?? "").data(using: .utf8)!
                let manualBarcodeObj = try JSONDecoder().decode([ManualEntryModel].self, from: manualBarcodeJsonData)
                surgeryObj.manualEntryCodes = manualBarcodeObj
                
                //                Use Stock data Object for easy handling on UI
                var surgeryDataObj = SurgeryData(addSurgeryTempObj: surgeryObj)
                surgeryDataObj.surgery_id = surgeryObj.surgeryId
                addedSurgeryArr.append(surgeryDataObj)
            }
            return addedSurgeryArr
        } catch {
            //GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return nil
    }
    
    //    #MARK: Update inventory status
    func updateStockStatus(stockId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddStock")
        fetchRequest.predicate = NSPredicate(format: "stockId == %@", stockId)
        do {
            let sergeryData = try managedContext.fetch(fetchRequest).first as? AddStock
            sergeryData?.isSyncedWithServer = true
            try managedContext.save()
        } catch {
            //GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
    }
    
    //    #MARK: Delete inventory 
    func deleteStockByStockId(stockId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddStock")
        fetchRequest.predicate = NSPredicate(format: "stockId == %@", stockId)
        do {
            if let sergeryData = try managedContext.fetch(fetchRequest).first as? AddStock {
                managedContext.delete(sergeryData)
                try managedContext.save()
                //GlobalFunctions.printToConsole(message: "Deleted Surgery id is: \(stockId)")
            }
        } catch {
            //GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
    }
}

