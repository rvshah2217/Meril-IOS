//
//  SurgeryListmodel.swift
//  Meril
//
//  Created by iMac on 26/03/22.
//

import Foundation

//struct SurgeryModel : Codable {
//    let success : Bool?
//    let message : String?
//    let surgeryListModel : [SurgeryListModel]?
//
//    enum CodingKeys: String, CodingKey {
//
//        case success = "success"
//        case message = "message"
//        case surgeryListModel = "data"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        success = try values.decodeIfPresent(Bool.self, forKey: .success)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        surgeryListModel = try values.decodeIfPresent([SurgeryListModel].self, forKey: .surgeryListModel)
//    }
//}
//
//struct SurgeryListModel : Codable {
//    let id : Int?
//    let zoho_id : String?
//    let surgery_id : String?
//    let user_id : String?
//    let unique_id : String?
//    let city_id : String?
//    let hospital_id : String?
//    let distri_id : String?
//    let division_id : String?
//    let patient_name : String?
//    let age : String?
//    let scheme_id : String?
//    let udt_id : String?
//    let ip_code : String?
//    let p_phone : String?
//    let p_email : String?
//    let company_id : String?
//    let manager_id : String?
//    let status : String?
//    let created_at : String?
//    let updated_at : String?
//    let doctor_id : String?
//    let scans : [Scans]?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case zoho_id = "zoho_id"
//        case surgery_id = "surgery_id"
//        case user_id = "user_id"
//        case unique_id = "unique_id"
//        case city_id = "city_id"
//        case hospital_id = "hospital_id"
//        case distri_id = "distri_id"
//        case division_id = "division_id"
//        case patient_name = "patient_name"
//        case age = "age"
//        case scheme_id = "scheme_id"
//        case udt_id = "udt_id"
//        case ip_code = "ip_code"
//        case p_phone = "p_phone"
//        case p_email = "p_email"
//        case company_id = "company_id"
//        case manager_id = "manager_id"
//        case status = "status"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//        case doctor_id = "doctor_id"
//        case scans = "scans"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        zoho_id = try values.decodeIfPresent(String.self, forKey: .zoho_id)
//        surgery_id = try values.decodeIfPresent(String.self, forKey: .surgery_id)
//        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
//        unique_id = try values.decodeIfPresent(String.self, forKey: .unique_id)
//        city_id = try values.decodeIfPresent(String.self, forKey: .city_id)
//        hospital_id = try values.decodeIfPresent(String.self, forKey: .hospital_id)
//        distri_id = try values.decodeIfPresent(String.self, forKey: .distri_id)
//        division_id = try values.decodeIfPresent(String.self, forKey: .division_id)
//        patient_name = try values.decodeIfPresent(String.self, forKey: .patient_name)
//        age = try values.decodeIfPresent(String.self, forKey: .age)
//        scheme_id = try values.decodeIfPresent(String.self, forKey: .scheme_id)
//        udt_id = try values.decodeIfPresent(String.self, forKey: .udt_id)
//        ip_code = try values.decodeIfPresent(String.self, forKey: .ip_code)
//        p_phone = try values.decodeIfPresent(String.self, forKey: .p_phone)
//        p_email = try values.decodeIfPresent(String.self, forKey: .p_email)
//        company_id = try values.decodeIfPresent(String.self, forKey: .company_id)
//        manager_id = try values.decodeIfPresent(String.self, forKey: .manager_id)
//        status = try values.decodeIfPresent(String.self, forKey: .status)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//        doctor_id = try values.decodeIfPresent(String.self, forKey: .doctor_id)
//        scans = try values.decodeIfPresent([Scans].self, forKey: .scans)
//    }
//}
//
//struct Scans : Codable {
//    let id : Int?
//    let zoho_id : String?
//    let surgery_id : String?
//    let barcode : String?
//    let product_code : String?
//    let gtin : String?
//    let mfg_date : String?
//    let exp_date : String?
//    let batch_no : String?
//    let scan_datetime : String?
//    let serial_no : String?
//    let created_at : String?
//    let updated_at : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case zoho_id = "zoho_id"
//        case surgery_id = "surgery_id"
//        case barcode = "barcode"
//        case product_code = "product_code"
//        case gtin = "gtin"
//        case mfg_date = "mfg_date"
//        case exp_date = "exp_date"
//        case batch_no = "batch_no"
//        case scan_datetime = "scan_datetime"
//        case serial_no = "serial_no"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        zoho_id = try values.decodeIfPresent(String.self, forKey: .zoho_id)
//        surgery_id = try values.decodeIfPresent(String.self, forKey: .surgery_id)
//        barcode = try values.decodeIfPresent(String.self, forKey: .barcode)
//        product_code = try values.decodeIfPresent(String.self, forKey: .product_code)
//        gtin = try values.decodeIfPresent(String.self, forKey: .gtin)
//        mfg_date = try values.decodeIfPresent(String.self, forKey: .mfg_date)
//        exp_date = try values.decodeIfPresent(String.self, forKey: .exp_date)
//        batch_no = try values.decodeIfPresent(String.self, forKey: .batch_no)
//        scan_datetime = try values.decodeIfPresent(String.self, forKey: .scan_datetime)
//        serial_no = try values.decodeIfPresent(String.self, forKey: .serial_no)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//    }
//
//}
