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
    let userTypes : [UserTypes]?    

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case userTypes = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        userTypes = try values.decodeIfPresent([UserTypes].self, forKey: .userTypes)
    }

}

struct UserTypes : Codable {
    let id : Int?
    let zoho_id : Int?
    let name : String?
    let created_at : String?
    let updated_at : String?
    
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

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        zoho_id = try values.decodeIfPresent(Int.self, forKey: .zoho_id)
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

    }

}
