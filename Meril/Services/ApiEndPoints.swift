//
//  ApiEndPoints.swift
//  Run
//
//  Created by iMac on 17/12/20.
//  Copyright © 2020 Nidhi Suhagiya. All rights reserved.
//

import Foundation
import Alamofire

protocol EndPointType {
    
    // MARK: - Vars & Lets
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
}


// Define a set of environments on a server side
enum NetworkEnvironment {
    case dev
    case production
    case stage
}

enum EndPointsItem {
    
    // #MARK:- User actions
    case login
    case getHomeBanners
    case getUserTypesApi
    case getFormData
    case getProfile
    case settings
    case addSurgery
    case addStock
    case getSurgeryList
    case getStockList
    case logout
    case changePassword
    case contactUs
    case barcode
    case surgeryList
    case updateHospital
    case products
}
enum pageType {
    case PrivacyPolicy
    case AboutUs
}
//#MARK:- Extensions endpoints
extension EndPointsItem: EndPointType {
    
    var baseURL: String {
        switch APIManager.networkEnviroment {
        case .dev: return "https://houseofgames.in/merillife/api/"
        case .production: return "https://houseofgames.in/merillife/api/"//"http://RunWayCards.com/RWCWebApi/LiveAccount/mobileapi/"
        case .stage: return "https://houseofgames.in/merillife/api/"//"http://RunWayCards.com/RWCWebApi/LiveAccount/mobileapi/"
        }
    }
    
    var version: String {
        return "/v0_1"
    }
    
    var path: String {
        switch self {
            
        case .login:
            return "login"
        case .getHomeBanners:
            return "banners"
        case .getUserTypesApi:
            return "userTypes"
        case .getFormData:
            return "form-data"
        case .getProfile:
            return "profile"
        case .settings:
            return "settings"
        case .addSurgery:
            return "surgery"
        case .getSurgeryList:
            return "surgery"
        case .addStock:
            return "stock"
        case .getStockList:
            return "stock"
        case .logout:
            return "logout"
        case .changePassword:
            return "change-password"
        case .contactUs:
            return "feedback"
        case .barcode:
            return "barcode"
        case .surgeryList:
            return "surgery"
        case .updateHospital:
            return "update-hospital"
        case .products:
            return "products"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getUserTypesApi, .getHomeBanners, .getFormData, .getProfile, .settings, .getSurgeryList, .getStockList, .barcode, .products:
            return .get
        default:
            return .post
        }
    }
    
    var tokenHeader : HTTPHeaders {
        if let token = UserDefaults.standard.string(forKey: "headerToken") {
            return ["Authorization" : "Bearer \(token)", "Accept": "application/json"]//"Bearer \(token)"]
        }else {
            return ["Accept": "application/json"]//[:]
        }
    }
    
    var headers: HTTPHeaders? {
        return tokenHeader
//        switch self {
//        case .login, .getUserTypesApi:
//            return nil//["Accept": "application/json"]
//        default:
//            return tokenHeader
//        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
//    If the API requires body or querystring encoding, it can be specified here
    var encoding: ParameterEncoding {
        switch self {
        case .barcode:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}
