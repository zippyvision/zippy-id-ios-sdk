//
//  ZippyCustomerData.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 10/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
public struct ZippyCustomerData: Codable {
    public var full_name: String?
    public var first_name: String?
    public var middle_name: String?
    public var last_name: String?
    public var province_1: String?
    public var province_2: String?
    public var city: String?
    public var state: String?
    public var gender: String?
    public var address: String?
    public var religion: String?
    public var zip_code: String?
    public var birth_date: String?
    public var blood_type: String?
    public var occupation: String?
    public var birth_place: String?
    public var nationality: String?
    public var document_date: String?
    public var personal_code: String?
    public var validity_date: String?
    public var marital_status: String?
    public var document_issuer: String?
    public var document_number: String?
}
