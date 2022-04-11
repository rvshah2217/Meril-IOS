//
//  SurgeryInventoryModel.swift
//  Meril
//
//  Created by Nidhi Suhagiya on 27/03/22.
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
    
//    For inventory and surgeryList
    let Account_Name: String?
    let Full_Name: String?//Can't make it common because android demo already given

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case unique_id = "unique_id"
        case email = "email"
        case name = "name"
        case city = "city"
        
        case fullname = "fullname"
        case Account_Name = "Account_Name"
        case Full_Name = "Full_Name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        unique_id = try values.decodeIfPresent(String.self, forKey: .unique_id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
        Account_Name = try values.decodeIfPresent(String.self, forKey: .Account_Name)
        Full_Name = try values.decodeIfPresent(String.self, forKey: .Full_Name)
    }

}

struct Cities : Codable {
  
    let id : Int?
    let zoho_id : Int?
    let country_id : Int?
    let state_id : Int?
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
        zoho_id = try values.decodeIfPresent(Int.self, forKey: .zoho_id)
        country_id = try values.decodeIfPresent(Int.self, forKey: .country_id)
        state_id = try values.decodeIfPresent(Int.self, forKey: .state_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        hospitals = try values.decodeIfPresent([Hospitals].self, forKey: .hospitals)
    }

}

struct AddSurgeryRequestModel : Codable {
    
    var cityId : Int?
    var hospitalId : Int?
    var distributorId: Int?
    var doctorId: Int?

    var schemeId : Int?
    var surgeryId: String?
//    var udtId: Int?
    var patientName : String?
    var patientMobile: String?
    var age: Int?
    
    var ipCode: String?
    var barcodes: String?//[BarCodeModel]?
    var salesPersonId: Int?
    var stockId: String?
    var gender: String?
    var DeploymentDate: String?
    var coreDataBarcodes: [BarCodeModel]?
   
    init(hospitalId : Int?,  distributorId: Int?, salesPersonId: Int?, stockId: String?, barcodes: String? = nil) {
        self.hospitalId = hospitalId
//        self.doctorId = doctorId
        self.distributorId = distributorId
        self.salesPersonId = salesPersonId
        self.stockId = stockId
        self.barcodes = barcodes
    }
//
    init(cityId : Int? = nil, hospitalId : Int?,  distributorId: Int?, doctorId: Int?, surgeryId: String? = nil, schemeId : Int? = nil, patientName : String? = nil, patientMobile: String? = nil, age: Int? = nil, ipCode: String? = nil, barcodes: String? = nil, salesPersonId: Int? = nil, stockId: String? = nil, gender: String? = nil, DeploymentDate: String? = nil) {
        self.cityId = cityId
        self.hospitalId = hospitalId
        self.doctorId = doctorId
        self.distributorId = distributorId
        self.surgeryId = surgeryId
        self.schemeId = schemeId
//        self.udtId = udtId
        self.patientMobile = patientMobile
        self.age = age
        self.ipCode = ipCode
        self.barcodes = barcodes
        self.patientName = patientName
        self.salesPersonId = salesPersonId
        self.stockId = stockId
        self.gender = gender
        self.DeploymentDate = DeploymentDate
    }
}

struct BarCodeModel: Encodable, Decodable {
    let barcode : String
    let dateTime : String// Format: Y-m-d H:i:s
}

struct SurgeryListResponseModel : Codable {
    let success : Bool?
    let message : String?
    let surgeryData : [SurgeryData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case surgeryData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        surgeryData = try values.decodeIfPresent([SurgeryData].self, forKey: .surgeryData)
    }

}

struct SurgeryData : Codable {
    var id : Int?
    var zoho_id : String?
    var surgery_id : String?
    var user_id : Int?
    var unique_id : String?
    var city_id : Int?
    var hospital_id : Int?
    var distri_id : Int?
    var division_id : Int?
    var patient_name : String?
    var age : Int?
    var scheme_id : Int?
    var udt_id : Int?
    var ip_code : String?
    var p_phone : String?
    var p_email : String?
    var company_id : Int?
    var manager_id : Int?
    var status : String?
    var created_at : String?
    var updated_at : String?
    var doctor_id : Int?
    var sales_person_id: Int?
    var scans : [Scans]?//? = []
    var stock_id: String?
    var hospital: Hospitals?
    var doctor: Hospitals?
    var sales_person: Hospitals?
    
    var addSurgeryTempObj: AddSurgeryRequestModel?
    
    init(addSurgeryTempObj: AddSurgeryRequestModel) {
        self.addSurgeryTempObj = addSurgeryTempObj
    }
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case zoho_id = "zoho_id"
        case surgery_id = "surgery_id"
        case user_id = "user_id"
        case unique_id = "unique_id"
        case city_id = "city_id"
        case hospital_id = "hospital_id"
        case distri_id = "distri_id"
        case division_id = "division_id"
        case patient_name = "patient_name"
        case age = "age"
        case scheme_id = "scheme_id"
        case udt_id = "udt_id"
        case ip_code = "ip_code"
        case p_phone = "p_phone"
        case p_email = "p_email"
        case company_id = "company_id"
        case manager_id = "manager_id"
        case status = "status"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case doctor_id = "doctor_id"
        case scans = "scans"
        case sales_person_id = "sales_person_id"
        case stock_id = "stock_id"
        case hospital = "hospital"
        case doctor = "doctor"
        case sales_person = "sales_person"
    }

    init() { }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        zoho_id = try values.decodeIfPresent(String.self, forKey: .zoho_id)
        surgery_id = try values.decodeIfPresent(String.self, forKey: .surgery_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        unique_id = try values.decodeIfPresent(String.self, forKey: .unique_id)
        city_id = try values.decodeIfPresent(Int.self, forKey: .city_id)
        hospital_id = try values.decodeIfPresent(Int.self, forKey: .hospital_id)
        distri_id = try values.decodeIfPresent(Int.self, forKey: .distri_id)
        division_id = try values.decodeIfPresent(Int.self, forKey: .division_id)
        patient_name = try values.decodeIfPresent(String.self, forKey: .patient_name)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        scheme_id = try values.decodeIfPresent(Int.self, forKey: .scheme_id)
        udt_id = try values.decodeIfPresent(Int.self, forKey: .udt_id)
        ip_code = try values.decodeIfPresent(String.self, forKey: .ip_code)
        p_phone = try values.decodeIfPresent(String.self, forKey: .p_phone)
        p_email = try values.decodeIfPresent(String.self, forKey: .p_email)
        company_id = try values.decodeIfPresent(Int.self, forKey: .company_id)
        manager_id = try values.decodeIfPresent(Int.self, forKey: .manager_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
//        if appDelegate.reachability.connection == .unavailable {
//            created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        } else {
            let currentDate: String? = try values.decodeIfPresent(String.self, forKey: .created_at)
            created_at = (convertStringToDateStr(str: currentDate) == nil) ? currentDate : convertStringToDateStr(str: currentDate)
//        }
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        doctor_id = try values.decodeIfPresent(Int.self, forKey: .doctor_id)
        scans = try values.decodeIfPresent([Scans].self, forKey: .scans) ?? []
        sales_person_id = try values.decodeIfPresent(Int.self, forKey: .sales_person_id)
        stock_id = try values.decodeIfPresent(String.self, forKey: .stock_id)
        hospital = try values.decodeIfPresent(Hospitals.self, forKey: .hospital)
        doctor = try values.decodeIfPresent(Hospitals.self, forKey: .doctor)
        sales_person = try values.decodeIfPresent(Hospitals.self, forKey: .sales_person)
//        addSurgeryTempObj = try values.decodeIfPresent(AddSurgeryRequestModel.self, forKey: .addSurgeryTempObj)
    }
}

struct Scans : Codable {
    let id : Int?
    let zoho_id : String?
    let surgery_id : Int?
    let stock_id : Int?
    let barcode : String?
    let product_code : String?
    let gtin : String?
    let mfg_date : String?
    let exp_date : String?
    let batch_no : String?
    let scan_datetime : String?
    let serial_no : String?
    let created_at : String?
    let updated_at : String?
    let product_data : Product_data?
    var status: String? = "invalid_barcode"
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case zoho_id = "zoho_id"
        case surgery_id = "surgery_id"
        case stock_id = "stock_id"
        case barcode = "barcode"
        case product_code = "product_code"
        case gtin = "gtin"
        case mfg_date = "mfg_date"
        case exp_date = "exp_date"
        case batch_no = "batch_no"
        case scan_datetime = "scan_datetime"
        case serial_no = "serial_no"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case product_data = "product_data"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        zoho_id = try values.decodeIfPresent(String.self, forKey: .zoho_id)
        surgery_id = try values.decodeIfPresent(Int.self, forKey: .surgery_id)
        stock_id = try values.decodeIfPresent(Int.self, forKey: .stock_id)
        barcode = try values.decodeIfPresent(String.self, forKey: .barcode)
        product_code = try values.decodeIfPresent(String.self, forKey: .product_code)
        gtin = try values.decodeIfPresent(String.self, forKey: .gtin)
        mfg_date = try values.decodeIfPresent(String.self, forKey: .mfg_date)
        exp_date = try values.decodeIfPresent(String.self, forKey: .exp_date)
        batch_no = try values.decodeIfPresent(String.self, forKey: .batch_no)
        scan_datetime = try values.decodeIfPresent(String.self, forKey: .scan_datetime)
        serial_no = try values.decodeIfPresent(String.self, forKey: .serial_no)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        product_data = try values.decodeIfPresent(Product_data.self, forKey: .product_data)
    }

}

struct Product_data : Codable {
    let id : Int?
    let zoho_id : String?
    let name : String?
    let description : String?
    let product_category : String?
    let price : String?
    let gtin : String?
    let product_code : String?
    let barcode : String?
    let serial_no : String?
    let batch_no : String?
    let mfg_date : String?
    let exp_date : String?
    let tax : String?
    let division_id : String?
    let mrp : String?
    let list_price : String?
    let std_cost : String?
    let uom : String?
    let segment : String?
    let speciality : String?
    let company_id : Int?
    let hsn_code_short : String?
    let hsn_code : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case zoho_id = "zoho_id"
        case name = "name"
        case description = "description"
        case product_category = "product_category"
        case price = "price"
        case gtin = "gtin"
        case product_code = "product_code"
        case barcode = "barcode"
        case serial_no = "serial_no"
        case batch_no = "batch_no"
        case mfg_date = "mfg_date"
        case exp_date = "exp_date"
        case tax = "tax"
        case division_id = "division_id"
        case mrp = "mrp"
        case list_price = "list_price"
        case std_cost = "std_cost"
        case uom = "uom"
        case segment = "segment"
        case speciality = "speciality"
        case company_id = "company_id"
        case hsn_code_short = "hsn_code_short"
        case hsn_code = "hsn_code"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        zoho_id = try values.decodeIfPresent(String.self, forKey: .zoho_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        product_category = try values.decodeIfPresent(String.self, forKey: .product_category)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        gtin = try values.decodeIfPresent(String.self, forKey: .gtin)
        product_code = try values.decodeIfPresent(String.self, forKey: .product_code)
        barcode = try values.decodeIfPresent(String.self, forKey: .barcode)
        serial_no = try values.decodeIfPresent(String.self, forKey: .serial_no)
        batch_no = try values.decodeIfPresent(String.self, forKey: .batch_no)
        mfg_date = try values.decodeIfPresent(String.self, forKey: .mfg_date)
        exp_date = try values.decodeIfPresent(String.self, forKey: .exp_date)
        tax = try values.decodeIfPresent(String.self, forKey: .tax)
        division_id = try values.decodeIfPresent(String.self, forKey: .division_id)
        mrp = try values.decodeIfPresent(String.self, forKey: .mrp)
        list_price = try values.decodeIfPresent(String.self, forKey: .list_price)
        std_cost = try values.decodeIfPresent(String.self, forKey: .std_cost)
        uom = try values.decodeIfPresent(String.self, forKey: .uom)
        segment = try values.decodeIfPresent(String.self, forKey: .segment)
        speciality = try values.decodeIfPresent(String.self, forKey: .speciality)
        company_id = try values.decodeIfPresent(Int.self, forKey: .company_id)
        hsn_code_short = try values.decodeIfPresent(String.self, forKey: .hsn_code_short)
        hsn_code = try values.decodeIfPresent(String.self, forKey: .hsn_code)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
