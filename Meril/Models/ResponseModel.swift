//
//  ResponseModel.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 22/03/22.
//

import Foundation

struct ResponseModel : Codable {
    let success : Bool?
    let message : String?
    let userTypes : [UserTypesModel]?    

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case userTypes = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        userTypes = try values.decodeIfPresent([UserTypesModel].self, forKey: .userTypes)
    }

}

struct UserTypesModel : Codable {
    let id : Int?
    let zoho_id : Int?
    let name : String?
    let created_at : String?
    let updated_at : String?
    let user_data : UserData?
    let is_default_password: Int?
    //    let sergeries : [Sergeries]?
//    let stocks : [Stocks]?

//    For login
    let user_type_id: Int?
    let unique_id: String?
    let token: String?
    
//    For banners
    let type : String?
    let link : String?
    let extra_parameter : String?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case zoho_id = "zoho_id"
        case name = "name"
        case created_at = "created_at"
        case updated_at = "updated_at"
        
        case user_type_id = "user_type_id"
        case unique_id = "unique_id"
        case token = "token"
        
        case type = "type"
        case link = "link"
        case extra_parameter = "extra_parameter"
        case image = "image"
//        case sergeries = "sergeries"
//        case stocks = "stocks"
        case user_data = "user_data"
        case is_default_password = "is_default_password"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        zoho_id = try values.decodeIfPresent(Int.self, forKey: .zoho_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
      
        user_type_id = try values.decodeIfPresent(Int.self, forKey: .user_type_id)
        unique_id = try values.decodeIfPresent(String.self, forKey: .unique_id)
        token = try values.decodeIfPresent(String.self, forKey: .token)

        type = try values.decodeIfPresent(String.self, forKey: .type)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        extra_parameter = try values.decodeIfPresent(String.self, forKey: .extra_parameter)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        
//        sergeries = try values.decodeIfPresent([Sergeries].self, forKey: .sergeries)
//        stocks = try values.decodeIfPresent([Stocks].self, forKey: .stocks)
        user_data = try values.decodeIfPresent(UserData.self, forKey: .user_data)
        is_default_password = try values.decodeIfPresent(Int.self, forKey: .is_default_password)
    }

}

struct UserData : Codable {
    let id : Int?
    let unique_id : String?
    let name : String?
    let email : String?
    let phone : String?
    let city : String?
    let state : String?
    let country : String?
    let pincode : Int?//String?
    let profile : String?
    let division_id : String?
    let gender : String?
    let bio: String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case unique_id = "unique_id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case city = "city"
        case state = "state"
        case country = "country"
        case pincode = "pincode"
        case profile = "profile"
        case division_id = "division_id"
        case gender = "gender"
        case bio = "bio"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        unique_id = try values.decodeIfPresent(String.self, forKey: .unique_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        pincode = try values.decodeIfPresent(Int.self, forKey: .pincode)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
        division_id = try values.decodeIfPresent(String.self, forKey: .division_id)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
    }

}

struct UserProfileResponseModel : Codable {
    let success : Bool?
    let message : String?
    let userProfile : UserData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case userProfile = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        userProfile = try values.decodeIfPresent(UserData.self, forKey: .userProfile)
    }

}

