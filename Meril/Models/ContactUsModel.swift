//
//  ContactUsModel.swift
//  Meril
//
//  Created by iMac on 26/03/22.
//

import Foundation
struct ContactUsRequestModel : Encodable {
    let name : String?
    let email: String?
    let subject : String?
    let message: String?
}
