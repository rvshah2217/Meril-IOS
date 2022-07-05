//
//  Constants.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit


let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let sidemenuStoryboard = UIStoryboard(name: "Sidemenu", bundle: nil)
let deviceToken = UserDefaults.standard.string(forKey: "fcmToken") ?? "12345"//UserDefaults.standard.string(forKey: "deviceToken")
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

let errorDismissTime = 2.5
let successDismissTime = 0.3

struct ColorConstant {
    static let mainThemeColor = UIColor(hexString: "#317ac3") ?? UIColor.systemBlue//"#4476BB"
}

struct DeviceConstant {
    static let deviceWidth = UIScreen.main.bounds.width
    static let deviceHeight = UIScreen.main.bounds.height
}

struct ApiConstant {
    static let baseUrl = "https://houseofgames.in/merillife/api/"
    static let loginApi = "login"
    static let getHomeDataApi = "banners"
    static let surgeryListApi = ""
    static let inventeryListApi = ""
}

struct UserMessages {
    static let defaultAlertTitle = "Error"
    static let serverError = "Something went wrong! Please try again later."
    static let emptyCityError = "Please select city."
    static let emptyHospitalError = "Please select hospital."
    static let emptyDoctorError = "Please select doctor."
    static let emptyDistributorError = "Please select distributor."
    static let emptySalesPersonError = "Please select sales person."
    static let emptyDivisionError = "Please select division."
    static let emptyGenderError = "Please select gender."
    static let emptyDateError = "Please select deployment date."
    static let productCode = "Please enter product code"
    static let batchNo = "Please enter batch number"
    static let serialNo = "Please enter serial number"

}
