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
}
