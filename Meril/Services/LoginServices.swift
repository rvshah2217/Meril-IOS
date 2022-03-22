//
//  CheckOutServices.swift
//  Run
//
//  Created by iMac on 24/12/20.
//  Copyright © 2020 Nidhi Suhagiya. All rights reserved.
//

import UIKit

class LoginServices {
    
    static func getUserTypes(completionHandler: @escaping (ResponseModel?, _ error: String?) -> ()) {
        
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
        let params: [String:Any] = [:]
        
        APIManager.shared().call(for: ResponseModel.self, type: EndPointsItem.getUserTypesApi, params: params) { (responseData, error) in
            
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
                return completionHandler(nil, error?.body)
            }
            
            return completionHandler(response, nil)
        }
    }
}
