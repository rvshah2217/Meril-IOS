//
//  Constants.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit


let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let sidemenuStoryboard = UIStoryboard(name: "Sidemenu", bundle: nil)
let deviceToken = "123456"//UserDefaults.standard.string(forKey: "deviceToken")

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
}
