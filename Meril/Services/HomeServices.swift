//
//  HomeServices.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 23/03/22.
//

import Foundation

class HomeServices {
    
    //    Fetch user types
    static func getBannerList(completionHandler: @escaping (ResponseModel?, _ error: String?) -> ()) {
        
        APIManager.shared().call(for: ResponseModel.self, type: EndPointsItem.getHomeBanners) { (responseData, error) in
            guard let response = responseData else {
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

