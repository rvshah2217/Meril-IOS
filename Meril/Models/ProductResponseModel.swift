//
//  ProductResponseModel.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 06/07/22.
//

import Foundation

struct ProductResponseModel: Codable {
    let success : Bool?
    let message : String?
    let productData : [ProductData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case productData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        productData = try values.decodeIfPresent([ProductData].self, forKey: .productData)
    }

}

struct ProductData : Codable {
    let id : Int?
    let flag : String?
    let hsn_code: String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case flag = "flag"
        case hsn_code = "hsn_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
        hsn_code = try values.decodeIfPresent(String.self, forKey: .hsn_code)
    }

}
