//
//  ChangePasswordModel.swift
//  Meril
//
//  Created by iMac on 26/03/22.
//

import Foundation
struct ChangePasswordRequestModel : Encodable {
    let currentPassword : String?
    let newPassword: String?
}
