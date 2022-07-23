//
//  AppDelegate.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Reachability
import FirebaseMessaging
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    //    var settingsData : SettingsData?
    let reachability = try! Reachability()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        Firebase configure
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        //        Config IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = ColorConstant.mainThemeColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.addNetworkReachability()
        //        self.getUserProfile()
        
        let vc: UIViewController
        if UserDefaults.standard.string(forKey: "headerToken") != nil {
            if UserDefaults.standard.bool(forKey: "isDefaultPassword") {
                let changePasswordVC = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
                changePasswordVC.isFromLogin = true
                vc = GlobalFunctions.setRootNavigationController(currentVC: changePasswordVC)
            } else {
                //                If usertype == 2(hospital) and distributor or salesperson id is nil then allow user to select default doctor, distributor and sales person
                let userTypeId = UserDefaults.standard.string(forKey: "userTypeId")
                let userData = UserSessionManager.shared.userDetail
                if let userTypeId = userTypeId, userTypeId == "2", ((userData?.distributor_id == nil) || userData?.sales_person_id == nil) {
                   let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "DefaultLoginData") as! DefaultLoginData
                    vc = GlobalFunctions.setRootNavigationController(currentVC: nextVC)
                } else {
                    self.fetchAndStoredDataLocally()
                    vc = GlobalFunctions.setHomeVC()
                }
            }
        } else {
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc = GlobalFunctions.setRootNavigationController(currentVC: loginVC)
        }
        
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.window?.rootViewController = vc//
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func registerRemoteNotification(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }
    
    func fetchAndStoredDataLocally() {
        DispatchQueue.global(qos: .background).async {
            self.fetchSettingsData()
            CommonFunctions.getAllFormData {_ in
                //GlobalFunctions.printToConsole(message: "Form data stored successfully in local.")
            }
        }
    }
    
    func addNetworkReachability() {
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .unavailable:
            NotificationCenter.default.post(name: .networkLost, object: nil)
            //          notify to send the data to server which are not synced yet
            print("Network not reachable")
        case .wifi, .cellular:
            AddSurgeryInventory().fetchSurgeryBySyncStatus()
            print("Network reachable")
        default:
            print("None")
            //          Notify that network connection lost and store data to local if needed
        }
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Meril")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            //GlobalFunctions.printToConsole(message: container.name)
            //GlobalFunctions.printToConsole(message: container.debugDescription)
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchSettingsData(){
        SettingServices.getSettingsData{ response, error in
            guard let responseData = response else {
                //                hide banner view if there is error
                return
            }
            do {
                let encodedData = try JSONEncoder().encode(responseData.settingsData)
                let jsonStr = String(data: encodedData, encoding: String.Encoding.utf8)
                UserDefaults.standard.set(jsonStr, forKey: "settingsData")
            } catch {
                //GlobalFunctions.printToConsole(message: "Error to store user profile data: \(error.localizedDescription)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
