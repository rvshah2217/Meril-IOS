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
    let name : String?
    let created_at : String?
    let updated_at : String?
    let user_data : UserData?
    let is_default_password: Int?
    let surgeries : [SurgeryData]?
    let stocks : [SurgeryData]?
    
    //    For login
    let user_type_id: String?
    let unique_id: String?
    let token: String?
    
    //    For banners
    let type : String?
    let link : String?
    let extra_parameter : String?
    let image : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
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
        case surgeries = "sergeries"
        case stocks = "stocks"
        case user_data = "user_data"
        case is_default_password = "is_default_password"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        
        user_type_id = try values.decodeIfPresent(String.self, forKey: .user_type_id)
        unique_id = try values.decodeIfPresent(String.self, forKey: .unique_id)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        
        type = try values.decodeIfPresent(String.self, forKey: .type)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        extra_parameter = try values.decodeIfPresent(String.self, forKey: .extra_parameter)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        
        surgeries = try values.decodeIfPresent([SurgeryData].self, forKey: .surgeries)
        stocks = try values.decodeIfPresent([SurgeryData].self, forKey: .stocks)
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
    let pincode : Int?
    let profile : String?
    let division_id : String?
    let gender : String?
    let bio: String?
    var distributor_id: Int?
    let distributor_name: String?
    var sales_person_id: Int?
    let sales_person_name: String?
    var doctor_id: Int?
    let doctor_name: String?
    
    
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
        case distributor_id = "distributor_id"
        case distributor_name = "distributor_name"
        case sales_person_id = "sales_person_id"
        case sales_person_name = "sales_person_name"
        case doctor_id = "doctor_id"
        case doctor_name = "doctor_name"
        
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
        
        distributor_id = try values.decodeIfPresent(Int.self, forKey: .distributor_id)
        distributor_name = try values.decodeIfPresent(String.self, forKey: .distributor_name)
        sales_person_id = try values.decodeIfPresent(Int.self, forKey: .sales_person_id)
        sales_person_name = try values.decodeIfPresent(String.self, forKey: .sales_person_name)
        doctor_id = try values.decodeIfPresent(Int.self, forKey: .doctor_id)
        doctor_name = try values.decodeIfPresent(String.self, forKey: .doctor_name)
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

