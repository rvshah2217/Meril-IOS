//
//  Constants.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 21/03/22.
//

import UIKit


let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let sidemenuStoryboard = UIStoryboard(name: "Sidemenu", bundle: nil)

struct ColorConstant {
    static let mainThemeColor = "#4476BB"
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
