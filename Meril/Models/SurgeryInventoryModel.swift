//
//  SurgeryInventoryModel.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 25/03/22.
//

import Foundation

struct FormDataResponseModel : Codable {
    
    let success : Bool?
    let message : String?
    let suregeryInventoryData: SurgeryInventoryModel?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case suregeryInventoryData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        suregeryInventoryData = try values.decodeIfPresent(SurgeryInventoryModel.self, forKey: .suregeryInventoryData)
    }

}

struct SurgeryInventoryModel : Codable {
    let schemes : [Schemes]?
    let udt : [Schemes]?
    let cities : [Cities]?
    let hospitals : [Hospitals]?
    let doctors : [Hospitals]?
    let distributors : [Hospitals]?
    let departments : [Schemes]?
    let sales_persons : [Hospitals]?

    enum CodingKeys: String, CodingKey {

        case schemes = "schemes"
        case udt = "udt"
        case cities = "cities"
        case hospitals = "hospitals"
        case doctors = "doctors"
        case distributors = "distributors"
        case departments = "departments"
        case sales_persons = "sales_persons"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cities = try values.decodeIfPresent([Cities].self, forKey: .cities)

        schemes = try values.decodeIfPresent([Schemes].self, forKey: .schemes)
        udt = try values.decodeIfPresent([Schemes].self, forKey: .udt)
        departments = try values.decodeIfPresent([Schemes].self, forKey: .departments)

        hospitals = try values.decodeIfPresent([Hospitals].self, forKey: .hospitals)
        doctors = try values.decodeIfPresent([Hospitals].self, forKey: .doctors)
        distributors = try values.decodeIfPresent([Hospitals].self, forKey: .distributors)
        sales_persons = try values.decodeIfPresent([Hospitals].self, forKey: .sales_persons)
    }

}

struct Schemes : Codable {
    let id : Int?
    let zoho_id : String?
    let scheme_name : String?
    let created_at : String?
    let updated_at : String?
    let dept_name : String?

//    For UDT
    let udt_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case zoho_id = "zoho_id"
        case scheme_name = "scheme_name"
        case created_at = "created_at"
        case updated_at = "updated_at"
        
        case udt_name = "udt_name"
        case dept_name = "dept_name"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        zoho_id = try values.decodeIfPresent(String.self, forKey: .zoho_id)
        scheme_name = try values.decodeIfPresent(String.self, forKey: .scheme_name)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        
        udt_name = try values.decodeIfPresent(String.self, forKey: .udt_name)
        dept_name = try values.decodeIfPresent(String.self, forKey: .dept_name)

    }

}

struct Hospitals : Codable {
    let id : Int?
    let unique_id : String?
    let email : String?
    let name : String?
    let city : String?

//    For Doctors
    let fullname : String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case unique_id = "unique_id"
        case email = "email"
        case name = "name"
        case city = "city"
        
        case fullname = "fullname"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        unique_id = try values.decodeIfPresent(String.self, forKey: .unique_id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
    }

}

struct Cities : Codable {
    let id : Int?
    let zoho_id : String?
    let country_id : String?
    let state_id : String?
    let name : String?
    let created_at : String?
    let updated_at : String?
    let hospitals : [Hospitals]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case zoho_id = "zoho_id"
        case country_id = "country_id"
        case state_id = "state_id"
        case name = "name"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case hospitals = "hospitals"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        zoho_id = try values.decodeIfPresent(String.self, forKey: .zoho_id)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        hospitals = try values.decodeIfPresent([Hospitals].self, forKey: .hospitals)
    }

}
