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
    let loginUserData: UserTypes?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case loginUserData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        loginUserData = try values.decodeIfPresent(UserTypes.self, forKey: .loginUserData)
    }

}

struct LoginRequesModel : Encodable {
    
    let userTypeId : Int?
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
