//
//  SettingServices.swift
//  Meril
//
//  Created by iMac on 26/03/22.
//

import Foundation

class SettingServices {
    
    //    Fetch user types
    static func getSettingsData(completionHandler: @escaping (SettingsResponseModel?, _ error: String?) -> ()) {
        
        //        let params: [String:Any] = [:]
        APIManager.shared().call(for: SettingsResponseModel.self, type: EndPointsItem.settings) { (responseData, error) in
            
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
