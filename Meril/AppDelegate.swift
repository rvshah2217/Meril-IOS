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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var settingsData : SettingsData?
    let reachability = try! Reachability()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        Config IQKeyboardManager
        IQKeyboardManager.shared.enable = true

        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = ColorConstant.mainThemeColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        self.addNetworkReachability()
        FatchSettingsData()
        
        let vc: UIViewController
        if UserDefaults.standard.string(forKey: "headerToken") != nil {
//            vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            vc = GlobalFunctions.setHomeVC()
        } else {
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc = GlobalFunctions.setRootNavigationController(currentVC: loginVC)
        }
//        vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        vc = SurgerayListViewController(nibName: "SurgerayListViewController", bundle: nil)
        self.window?.rootViewController = vc//
        self.window?.makeKeyAndVisible()
        return true
    }

    func addNetworkReachability() {
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)

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
            GlobalFunctions.printToConsole(message: container.name)
            GlobalFunctions.printToConsole(message: container.debugDescription)
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
    
    func FatchSettingsData(){
        SettingServices.getSettingsData{ response, error in
            guard let responseData = response else {
                //                hide banner view if there is error
                return
            }
            self.settingsData = response?.settingsData
        }
    }
}

