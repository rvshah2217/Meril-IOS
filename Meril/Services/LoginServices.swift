//
//  CheckOutServices.swift
//  Run
//
//  Created by iMac on 24/12/20.
//  Copyright © 2020 Nidhi Suhagiya. All rights reserved.
//

import UIKit

class LoginServices {
    
    //    Fetch user types
    static func getUserTypes(completionHandler: @escaping (ResponseModel?, _ error: String?) -> ()) {
        
        //        let params: [String:Any] = [:]
        APIManager.shared().call(for: ResponseModel.self, type: EndPointsItem.getUserTypesApi) { (responseData, error) in
            
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
    
    //    user login
    static func userLogin(loginObj: LoginRequestModel, completionHandler: @escaping (LoginResponseModel?, _ error: String?) -> ()) {
                
        APIManager.shared().call(for: LoginResponseModel.self, type: EndPointsItem.login, params: loginObj.dict) { (responseData, error) in
            
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
    
    //    user login
    static func userLogOut(completionHandler: @escaping (LoginResponseModel?, _ error: String?) -> ()) {
                
        APIManager.shared().call(for: LoginResponseModel.self, type: EndPointsItem.logout) { (responseData, error) in
            
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
                return completionHandler(nil, error?.body)
            }
            
            //Check if server return success response or not
            if response.success ?? false {
//                Remove data stored locally
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                return completionHandler(response, nil)
            } else {
                return completionHandler(nil, response.message ?? UserMessages.serverError)
            }
        }
    }
}
