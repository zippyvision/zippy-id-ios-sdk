//
//  ZippyCountry.swift
//  ZippyIdSDK
//
//  Created by Melānija Grunte on 16/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public struct ZippyCountry {
    public var label: String
    public var value: String
    public var documentTypes: [ZippyDocumentType]
    
    public init(label: String, value: String, documentTypes: [ZippyDocumentType]) {
        self.label = label
        self.value = value
        self.documentTypes = documentTypes
    }
}

var indonesia = ZippyCountry(label: "Indonesia", value: "id", documentTypes: [.idCard])
var latvia = ZippyCountry(label: "Latvia", value: "lv", documentTypes: [.idCard, .passport, . driversLicence])
var austria = ZippyCountry(label: "Austria", value: "at", documentTypes: [.idCard, .passport, . driversLicence])
var belgium = ZippyCountry(label: "Belgium", value: "be", documentTypes: [.idCard, .passport])
var bulgaria = ZippyCountry(label: "Bulgaria", value: "bg", documentTypes: [.idCard, .passport, .driversLicence])
var croatia = ZippyCountry(label: "Croatia", value: "hr", documentTypes: [.idCard, .passport, .driversLicence])
var czechRepublic = ZippyCountry(label: "Czech Republic", value: "cz", documentTypes: [.idCard, .driversLicence])
var estonia = ZippyCountry(label: "Estonia", value: "ee", documentTypes: [.idCard, .passport, . driversLicence])
var finland = ZippyCountry(label: "Finland", value: "fi", documentTypes: [.idCard, . driversLicence])
var germany = ZippyCountry(label: "Germany", value: "de", documentTypes: [.idCard, .passport, . driversLicence])
var hungary = ZippyCountry(label: "Hungary", value: "hu", documentTypes: [.idCard, .passport, . driversLicence])
var italy = ZippyCountry(label: "Italy", value: "it", documentTypes: [.idCard, .passport, . driversLicence])
var lithuania = ZippyCountry(label: "Lithuania", value: "lt", documentTypes: [.idCard, .passport, . driversLicence])
var poland = ZippyCountry(label: "Poland", value: "pl", documentTypes: [.passport, . driversLicence])
var portugal = ZippyCountry(label: "Portugal", value: "pt", documentTypes: [.idCard, .passport, . driversLicence])
var romania = ZippyCountry(label: "Romania", value: "ro", documentTypes: [.driversLicence])
var slovakia = ZippyCountry(label: "Slovakia", value: "sk", documentTypes: [.idCard, .passport, . driversLicence])
var spain = ZippyCountry(label: "Spain", value: "es", documentTypes: [.idCard, .passport, . driversLicence])

let countries: [ZippyCountry] = [indonesia, latvia, austria, belgium, bulgaria, croatia, czechRepublic, estonia, finland, germany, hungary, italy, lithuania, poland, portugal, romania, slovakia, spain]
