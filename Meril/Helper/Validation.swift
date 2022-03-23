//
//  Validation.swift
//  Run
//
//  Created by iMac on 17/12/20.
//  Copyright © 2020 Nidhi Suhagiya. All rights reserved.
//

import Foundation

class Validation {
    
    static let sharedInstance = Validation()
    
    //    E-mail validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //    check entered data is empty or not
    func checkLength(testStr:String) -> Bool {
        if testStr.trimmingCharacters(in: .whitespaces).isEmpty || testStr.count < 0 {
            return false
        } else {
            return true
        }
    }
    
    //    password validation
    func validatePassword(testStr:String) -> Bool {
        //        (                   # Start of group
        //            (?=.*\d)        #   must contain at least one digit
        //            (?=.*[A-Z])     #   must contain at least one uppercase character
        //            (?=.*\W)        #   must contain at least one special symbol
        //               .            #     match anything with previous condition checking
        //                 {8,8}      #        length is exactly 8 characters
        //        )                   # End of group
        let passwordRegEx = "^((?=.*\\d)(?=.*[A-Z]).{8,})$"//"^.{6,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluate(with: testStr)
    }
    
    //    user name validation
    func validateUserName(testStr:String) -> Bool {
        
        let regEx = "^.{3,18}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: testStr)
    }
    
    //    Validate phone number
    func validatePhonenumber(value: String) -> Bool {
        let PHONE_REGEX = "^.{10,}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
}

