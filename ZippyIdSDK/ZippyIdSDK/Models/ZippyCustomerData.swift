//
//  ZippyCustomerData.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 10/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public struct ZippyCustomerData: Codable {
    public var fullName: String?
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?
    public var province1: String?
    public var province2: String?
    public var city: String?
    public var state: String?
    public var gender: String?
    public var address: String?
    public var religion: String?
    public var zipCode: String?
    public var birthDate: String?
    public var bloodType: String?
    public var occupation: String?
    public var birthPlace: String?
    public var nationality: String?
    public var documentDate: String?
    public var personalCode: String?
    public var validityDate: String?
    public var maritalStatus: String?
    public var documentIssuer: String?
    public var documentNumber: String?
    
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name", firstName = "first_name", middleName = "middle_name", lastName = "last_name", province1 = "province_1", province2 = "province_2", city, state, gender, address, religion, zipCode = "zip_code", birthDate = "birth_date", bloodType = "blood_type", occupation, birthPlace = "birth_place", nationality, documentDate = "document_date", personalCode = "personal_code", validityDate = "validity_date", maritalStatus = "marital_status", documentIssuer = "document_issuer", documentNumber = "document_number"
    }
}
