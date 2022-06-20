//
//  APIManager.swift
//  Run
//
//  Created by iMac on 17/12/20.
//  Copyright © 2020 Nidhi Suhagiya. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    // MARK: - Vars & Lets
    
    private let sessionManager: Session
    static let networkEnviroment: NetworkEnvironment = .production// change this on app live
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        
        return apiManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    //    Api request
    func call<T>(for: T.Type = T.self, type: EndPointType, params: Parameters? = nil, completionHandler: @escaping (T?, _ error: AlertMessage?) -> ()) where T: Decodable {
        GlobalFunctions.printToConsole(message: "api url:- \(type.url)")
        GlobalFunctions.printToConsole(message: "auth token:- \(type.headers)")
        GlobalFunctions.printToConsole(message: "parameters:- \(params)")
        
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).responseJSON { json in
            switch json.result {
            case .success(_):
                if let jsonData = json.data {
                    GlobalFunctions.printToConsole(message: "Api response for \(type.url):- \(json.result)")
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(T.self, from: jsonData)
                    completionHandler(result, nil)
                }
                break
            case .failure(let error):
                GlobalFunctions.printToConsole(message: "api response error:- \(error.localizedDescription)")
                completionHandler(nil, self.parseApiError(data: json.data))
                break
            }
        }
    }
    
    //    parse api error
    private func parseApiError(data: Data?) -> AlertMessage {
        let decoder = JSONDecoder()
        if let jsonData = data, let error = try? decoder.decode(ErrorObject.self, from: jsonData) {
            return AlertMessage(title: UserMessages.defaultAlertTitle, body: error.key ?? error.message)
        }
        return AlertMessage(title: UserMessages.defaultAlertTitle, body: UserMessages.serverError)
    }
    
}

// #MARK:- alert strcut
struct AlertMessage {
    var title: String?
    var body : String?
    
}

// #MARK:- error object class
class ErrorObject: Codable {
    
    let message: String
    let key: String?
    
}
