//
//  LoginResponseModel.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 23/03/22.
//

import Foundation

struct LoginResponseModel : Codable {
    
    let success : Bool?
    let message : String?
    let loginUserData: UserTypesModel?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case loginUserData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        loginUserData = try values.decodeIfPresent(UserTypesModel.self, forKey: .loginUserData)
    }

}

struct LoginRequestModel : Encodable {
    
//    let userTypeId : Int?
    let username : String?
    let password: String?
    let fcmToken: String?

}

extension Encodable {

    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
//    Use above as movies.compactMap { $0.dict }

}


struct BarcodeStatusResponseModel : Codable {
    let success : Bool?
    let message : String?
    let barCodeStatusModel : BarCodeStatusModel?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case barCodeStatusModel = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        barCodeStatusModel = try values.decodeIfPresent(BarCodeStatusModel.self, forKey: .barCodeStatusModel)
    }

}

struct BarCodeStatusModel : Codable {
    let status : String?
    let barcode_data : Barcode_data?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case barcode_data = "barcode_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        barcode_data = try values.decodeIfPresent(Barcode_data.self, forKey: .barcode_data)
    }

}

struct Barcode_data : Codable {
    let gtin : String?
    let expiry : String?
    let serial : String?
//    let units : Int?
    let type : String?
    let product : ProductBarCode?

    enum CodingKeys: String, CodingKey {

        case gtin = "gtin"
        case expiry = "expiry"
        case serial = "serial"
//        case units = "units"
        case type = "type"
        case product = "product"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gtin = try values.decodeIfPresent(String.self, forKey: .gtin)
        expiry = try values.decodeIfPresent(String.self, forKey: .expiry)
        serial = try values.decodeIfPresent(String.self, forKey: .serial)
//        units = try values.decodeIfPresent(Int.self, forKey: .units)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        product = try values.decodeIfPresent(ProductBarCode.self, forKey: .product)
    }

}

struct ProductBarCode : Codable {
    let id : Int?
//    let zoho_id : String?
    let material : String?
//    let material_description : String?
//    let gtin : String?
//    let uom : String?
//    let company_id : Int?
//    let hsn_code : String?
//    let material_group_desc : String?
//    let material_group_desc1 : String?
//    let created_at : String?
//    let updated_at : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
//        case zoho_id = "zoho_id"
        case material = "material"
//        case material_description = "material_description"
//        case gtin = "gtin"
//        case uom = "uom"
//        case company_id = "company_id"
//        case hsn_code = "hsn_code"
//        case material_group_desc = "material_group_desc"
//        case material_group_desc1 = "material_group_desc1"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
        case flag = "flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        zoho_id = try values.decodeIfPresent(String.self, forKey: .zoho_id)
        material = try values.decodeIfPresent(String.self, forKey: .material)
//        material_description = try values.decodeIfPresent(String.self, forKey: .material_description)
//        gtin = try values.decodeIfPresent(String.self, forKey: .gtin)
//        uom = try values.decodeIfPresent(String.self, forKey: .uom)
//        company_id = try values.decodeIfPresent(Int.self, forKey: .company_id)
//        hsn_code = try values.decodeIfPresent(String.self, forKey: .hsn_code)
//        material_group_desc = try values.decodeIfPresent(String.self, forKey: .material_group_desc)
//        material_group_desc1 = try values.decodeIfPresent(String.self, forKey: .material_group_desc1)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }

}

