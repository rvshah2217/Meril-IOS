//
//  SurgeryServices.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 25/03/22.
//

import Foundation

class SurgeryServices {
    
    //    Fetch user types
    static func getAllFormData(completionHandler: @escaping (FormDataResponseModel?, _ error: String?) -> ()) {
        
        //        let params: [String:Any] = [:]
        APIManager.shared().call(for: FormDataResponseModel.self, type: EndPointsItem.getFormData) { (responseData, error) in
            
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
                return completionHandler(nil, error?.body)
            }
            //Check if server return success response or not
            if response.success ?? false {
                return completionHandler(response, nil)
            } else {
                return completionHandler(nil, response.message ?? UserMessages.serverError)
            }
        }
    }
    
    //    Fetch user types
    static func addSurgery(surgeryObj: AddSurgeryRequestModel, completionHandler: @escaping (ResponseModel?, _ error: String?) -> ()) {
                
        APIManager.shared().call(for: ResponseModel.self, type: EndPointsItem.addSurgery, params: surgeryObj.dict) { (responseData, error) in
            
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
                return completionHandler(nil, error?.body)
            }
            
            //Check if server return success response or not
            if response.success ?? false {
                return completionHandler(response, nil)
            } else {
                return completionHandler(nil, response.message ?? UserMessages.serverError)
            }
        }
    }
    
    //    Add inventory stock
    static func addInventoryStock(surgeryObj: AddSurgeryRequestModel, completionHandler: @escaping (ResponseModel?, _ error: String?) -> ()) {
                
        APIManager.shared().call(for: ResponseModel.self, type: EndPointsItem.addStock, params: surgeryObj.dict) { (responseData, error) in
            
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
                return completionHandler(nil, error?.body)
            }
            
            //Check if server return success response or not
            if response.success ?? false {
                return completionHandler(response, nil)
            } else {
                return completionHandler(nil, response.message ?? UserMessages.serverError)
            }
        }
    }
}

extension SurgeryServices {
    
    //    Fetch Surgery list
    static func getSurgeries(completionHandler: @escaping (SurgeryListResponseModel?, _ error: String?) -> ()) {
        
        //        let params: [String:Any] = [:]
        APIManager.shared().call(for: SurgeryListResponseModel.self, type: EndPointsItem.getSurgeryList) { (responseData, error) in
            
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
                return completionHandler(nil, error?.body)
            }
            //Check if server return success response or not
            if response.success ?? false {
                return completionHandler(response, nil)
            } else {
                return completionHandler(nil, response.message ?? UserMessages.serverError)
            }
        }
    }

    //    Fetch Surgery list
    static func getInventories(completionHandler: @escaping (SurgeryListResponseModel?, _ error: String?) -> ()) {
        
        //        let params: [String:Any] = [:]
        APIManager.shared().call(for: SurgeryListResponseModel.self, type: EndPointsItem.getStockList) { (responseData, error) in
            
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
                return completionHandler(nil, error?.body)
            }
            //Check if server return success response or not
            if response.success ?? false {
                return completionHandler(response, nil)
            } else {
                return completionHandler(nil, response.message ?? UserMessages.serverError)
            }
        }
    }
    
    //    Fetch user types
    static func checkBarcodeStatus(barCode: String, completionHandler: @escaping (BarcodeStatusResponseModel?, _ error: String?) -> ()) {
                
        APIManager.shared().call(for: BarcodeStatusResponseModel.self, type: EndPointsItem.barcode, params: ["barcode": barCode]) { (responseData, error) in
            
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
                return completionHandler(nil, error?.body)
            }
            
            //Check if server return success response or not
            if response.success ?? false {
                return completionHandler(response, nil)
            } else {
                return completionHandler(nil, response.message ?? UserMessages.serverError)
            }
        }
    }
}
