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
    let type : String?
    let product : ProductBarCode?
    
    enum CodingKeys: String, CodingKey {
        
        case gtin = "gtin"
        case expiry = "expiry"
        case serial = "serial"
        case type = "type"
        case product = "product"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gtin = try values.decodeIfPresent(String.self, forKey: .gtin)
        expiry = try values.decodeIfPresent(String.self, forKey: .expiry)
        serial = try values.decodeIfPresent(String.self, forKey: .serial)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        product = try values.decodeIfPresent(ProductBarCode.self, forKey: .product)
    }
    
}

struct ProductBarCode : Codable {
    
    let id : Int?
    let material : String?
    let flag : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case material = "material"
        case flag = "flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        material = try values.decodeIfPresent(String.self, forKey: .material)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }
    
}

enum CustomDataValue: Codable {
    
    case string(String)
    
    var stringValue: String? {
        switch self {
        case .string(let s):
            return s
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .string("\(x)")
            return
        }
        throw DecodingError.typeMismatch(CustomDataValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        }
    }
}
