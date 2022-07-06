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
    let productData : [ProductBarCode]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case productData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        productData = try values.decodeIfPresent([ProductBarCode].self, forKey: .productData)
    }

}

//struct ProductData : Codable {
//    let id : Int?
//    let flag : String?
//    let material: String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case flag = "flag"
//        case material = "material"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        flag = try values.decodeIfPresent(String.self, forKey: .flag)
//        material = try values.decodeIfPresent(String.self, forKey: .material)
//    }
//
//}
