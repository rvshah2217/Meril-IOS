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
//    func saveSurgeryData(surgeryData: SurgeryData) {
        do {
            let encodedData = try JSONEncoder().encode(surgeryData)
            let jsonStr = String(data: encodedData, encoding: String.Encoding.utf8)
            
            let entityFormData = NSEntityDescription.entity(forEntityName: "AddSurgeries", in: managedContext)!
            
            let surgeryObj = NSManagedObject(entity: entityFormData, insertInto: managedContext)
            surgeryObj.setValue(jsonStr, forKey: "addSurgeryStr")
            surgeryObj.setValue(Date(), forKey: "creationDate")
            surgeryObj.setValue(false, forKey: "isSyncedWithServer")
            surgeryObj.setValue(surgeryData.surgeryId, forKey: "surgeryId")
            
            try managedContext.save()
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to save FormData: \(error.localizedDescription)")
        }
    }
    
    func fetchSurgeries() -> [SurgeryData]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddSurgeries")
        fetchRequest.predicate = NSPredicate(format: "isSyncedWithServer == %@", NSNumber(value: false))
        do {
            let surgeryTypesData = try managedContext.fetch(fetchRequest) as? [AddSurgeries]
            var addedSurgeryArr: [SurgeryData] = []
            for surgery in surgeryTypesData ?? [] {
                let jsonData = (surgery.addSurgeryStr ?? "").data(using: .utf8)!
                var surgeryObj = try JSONDecoder().decode(AddSurgeryRequestModel.self, from: jsonData)
                
                //                Convert barcode array
                    let barcodeJsonData = (surgeryObj.barcodes ?? "").data(using: .utf8)!
                    let barcodeObj = try JSONDecoder().decode([BarCodeModel].self, from: barcodeJsonData)
                    surgeryObj.coreDataBarcodes = barcodeObj
                
//                Use Surgery data Object for easy handling on UI
                var surgeryDataObj = SurgeryData(addSurgeryTempObj: surgeryObj)
                surgeryDataObj.surgery_id = surgeryObj.surgeryId
                    addedSurgeryArr.append(surgeryDataObj)
            }
            return addedSurgeryArr
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch records: \(error.localizedDescription)")
        }
        return nil
    }
    
    func updateSurgeryStatus(surgeryId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddSurgeries")
        fetchRequest.predicate = NSPredicate(format: "surgeryId == %@", surgeryId)
        do {
            let sergeryData = try managedContext.fetch(fetchRequest).first as? AddSurgeries
            sergeryData?.isSyncedWithServer = true
            try managedContext.save()
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
    }
    
    func deleteSergeryBySurgeryId(surgeryId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AddSurgeries")
        fetchRequest.predicate = NSPredicate(format: "surgeryId == %@", surgeryId)
        do {
            if let sergeryData = try managedContext.fetch(fetchRequest).first as? AddSurgeries {
                managedContext.delete(sergeryData)
            }
            try managedContext.save()
            GlobalFunctions.printToConsole(message: "Deleted Surgery id is: \(surgeryId)")
        } catch {
            GlobalFunctions.printToConsole(message: "Unable to fetch FormData: \(error.localizedDescription)")
        }
    }
}

