//
//  CheckOutServices.swift
//  Run
//
//  Created by iMac on 24/12/20.
//  Copyright © 2020 Nidhi Suhagiya. All rights reserved.
//

import UIKit
import CoreData

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
    //    static func userLogOut(completionHandler: @escaping (LoginResponseModel?, _ error: String?) -> ()) {
    static func userLogOut(navController: UINavigationController) {
        let topController = navController.topViewController
        APIManager.shared().call(for: LoginResponseModel.self, type: EndPointsItem.logout) { (responseData, error) in
            
            //                Remove data from user defaults
            LoginServices.removeLocallyStoredData()
            
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            appDelegate.window?.rootViewController = GlobalFunctions.setRootNavigationController(currentVC: loginVC)
            appDelegate.window?.makeKeyAndVisible()

//            guard let response = responseData else {
//                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
//                if let vc = topController as? UIViewController {
//                    GlobalFunctions.showToast(controller: vc, message: error?.title ?? UserMessages.serverError, seconds: errorDismissTime, completionHandler: nil)
//                }
//                return
//            }
            
            //Check if server return success response or not
//            if response.success ?? false {
//                //                Remove data from user defaults
//                LoginServices.removeLocallyStoredData()
//
//                let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                appDelegate.window?.rootViewController = GlobalFunctions.setRootNavigationController(currentVC: loginVC)
//                appDelegate.window?.makeKeyAndVisible()
//
//            } else {
//                if let vc = topController as? UIViewController {
//                    GlobalFunctions.showToast(controller: vc, message: response.message ?? UserMessages.serverError, seconds: errorDismissTime, completionHandler: nil)
//                }
//            }
        }
    }
    
    //                Remove data stored locally
    static func removeLocallyStoredData() {
        //        Remove data from userdefaults
//        let isFirstTimeLogin = UserDefaults.standard.bool(forKey: "isFirstTimeLogInDone")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
//        UserDefaults.standard.set(isFirstTimeLogin, forKey: "isFirstTimeLogInDone")
        
        //        Remove data from core data
        // Get a reference to a managed object context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // List of multiple objects to delete
        let addSurgeryEntity = NSEntityDescription.entity(forEntityName: "AddSurgeries", in: managedContext)!
        let surgeryObj = NSManagedObject(entity: addSurgeryEntity, insertInto: managedContext)
        
        //        Stock object
        let addStockEntity = NSEntityDescription.entity(forEntityName: "AddStock", in: managedContext)!
        let stockObj = NSManagedObject(entity: addStockEntity, insertInto: managedContext)
        
        //        Home banners object
        let homeBannersEntity = NSEntityDescription.entity(forEntityName: "HomeBanners", in: managedContext)!
        let homeBannersObj = NSManagedObject(entity: homeBannersEntity, insertInto: managedContext)
        
        //        Form data object
        let formDataEntity = NSEntityDescription.entity(forEntityName: "FormData", in: managedContext)!
        let formDataObj = NSManagedObject(entity: formDataEntity, insertInto: managedContext)
        
        
        //        Surgery list object
        let surgeryListEntity = NSEntityDescription.entity(forEntityName: "SurgeryList", in: managedContext)!
        let surgeryListObj = NSManagedObject(entity: surgeryListEntity, insertInto: managedContext)
        
        //        Surgery list object
        let inventoryList = NSEntityDescription.entity(forEntityName: "InventoryList", in: managedContext)!
        let inventoryListObj = NSManagedObject(entity: inventoryList, insertInto: managedContext)
        
        let objects: [NSManagedObject] = [surgeryObj, stockObj, homeBannersObj, formDataObj, surgeryListObj, inventoryListObj]// A list of objects
        
        
        // Delete multiple objects
        for object in objects {
            managedContext.delete(object)
        }
        do {
            // Save the deletions to the persistent store
            try managedContext.save()
        } catch {
            GlobalFunctions.printToConsole(message: "Fail to delete objects")
        }
        
    }
}

extension LoginServices {
    //    Fetch user types
    static func getUserProfile(completionHandler: @escaping (UserProfileResponseModel?, _ error: String?) -> ()) {
        
        //        let params: [String:Any] = [:]
        APIManager.shared().call(for: UserProfileResponseModel.self, type: EndPointsItem.getProfile) { (responseData, error) in
            
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
    
//    Set default credentials of doctor, distributor and salesPerson
    static func setDefaultCredentials(credentialObj: CredentialsRequestModel, completionHandler: @escaping (_ isSuccess: Bool, _ error: String?) -> ()) {
                
        APIManager.shared().call(for: LoginResponseModel.self, type: EndPointsItem.updateHospital, params: credentialObj.dict) { (responseData, error) in
            GlobalFunctions.printToConsole(message: "Default credentials response: \(responseData?.message)")
            guard let response = responseData else {
                GlobalFunctions.printToConsole(message: "usertype error:- \(error?.title)")
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
