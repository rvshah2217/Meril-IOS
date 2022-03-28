//
//  SettingsModel.swift
//  Meril
//
//  Created by iMac on 26/03/22.
//

import Foundation
struct SettingsResponseModel : Codable {
    let success : Bool?
    let message : String?
    let settingsData : SettingsData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case settingsData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        settingsData = try values.decodeIfPresent(SettingsData.self, forKey: .settingsData)
    }

}
struct SettingsData : Codable {
    let id : Int?
    let app_desc : String?
    let privay_policy : String?
    let terms_condition : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case app_desc = "app_desc"
        case privay_policy = "privay_policy"
        case terms_condition = "terms_condition"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        app_desc = try values.decodeIfPresent(String.self, forKey: .app_desc)
        privay_policy = try values.decodeIfPresent(String.self, forKey: .privay_policy)
        terms_condition = try values.decodeIfPresent(String.self, forKey: .terms_condition)
    }

}
