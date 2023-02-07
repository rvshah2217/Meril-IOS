//
//  ChangePasswordServices.swift
//  Meril
//
//  Created by iMac on 26/03/22.
//

import Foundation

class ChangePasswordServices {
    static func changepassword(loginObj: ChangePasswordRequestModel, completionHandler: @escaping (_ isSuccess: Bool, _ error: String?) -> ()) {
        
        APIManager.shared().call(for: LoginResponseModel.self, type: EndPointsItem.changePassword, params: loginObj.dict) { (responseData, error) in
            
            guard let response = responseData else {
                return completionHandler(false, error?.body)
            }
            
            //Check if server return success response or not
            if response.success ?? false {
                return completionHandler(true, nil)
            } else {
                return completionHandler(false, response.message ?? UserMessages.serverError)
            }
        }
    }
}
