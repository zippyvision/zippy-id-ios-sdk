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

//var indonesia = ZippyCountry(label: "Indonesia", value: "id", documentTypes: [.idCard])
//var latvia = ZippyCountry(label: "Latvia", value: "lv", documentTypes: [.idCard, .passport, . driversLicence])
//var austria = ZippyCountry(label: "Austria", value: "at", documentTypes: [.idCard, .passport, . driversLicence])
//var belgium = ZippyCountry(label: "Belgium", value: "be", documentTypes: [.idCard, .passport])
//var bulgaria = ZippyCountry(label: "Bulgaria", value: "bg", documentTypes: [.idCard, .passport, .driversLicence])
//var croatia = ZippyCountry(label: "Croatia", value: "hr", documentTypes: [.idCard, .passport, .driversLicence])
//var czechRepublic = ZippyCountry(label: "Czech Republic", value: "cz", documentTypes: [.idCard, .driversLicence])
//var estonia = ZippyCountry(label: "Estonia", value: "ee", documentTypes: [.idCard, .passport, . driversLicence])
//var finland = ZippyCountry(label: "Finland", value: "fi", documentTypes: [.idCard, . driversLicence])
//var germany = ZippyCountry(label: "Germany", value: "de", documentTypes: [.idCard, .passport, . driversLicence])
//var hungary = ZippyCountry(label: "Hungary", value: "hu", documentTypes: [.idCard, .passport, . driversLicence])
//var italy = ZippyCountry(label: "Italy", value: "it", documentTypes: [.idCard, .passport, . driversLicence])
//var lithuania = ZippyCountry(label: "Lithuania", value: "lt", documentTypes: [.idCard, .passport, . driversLicence])
//var poland = ZippyCountry(label: "Poland", value: "pl", documentTypes: [.passport, . driversLicence])
//var portugal = ZippyCountry(label: "Portugal", value: "pt", documentTypes: [.idCard, .passport, . driversLicence])
//var romania = ZippyCountry(label: "Romania", value: "ro", documentTypes: [.driversLicence])
//var slovakia = ZippyCountry(label: "Slovakia", value: "sk", documentTypes: [.idCard, .passport, . driversLicence])
//var spain = ZippyCountry(label: "Spain", value: "es", documentTypes: [.idCard, .passport, . driversLicence])

let indonesia: [String: Any] = [
    "label":"Indonesia",
    "value": "id",
    "document_types": [ZippyDocumentType.idCard]
]
let latvia: [String: Any] = [
    "label":"Latvia",
    "value": "lv",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let austria: [String: Any] = [
    "label":"Austria",
    "value": "at",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let belgium: [String: Any] = [
    "label":"Belgium",
    "value": "be",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport]
]
let bulgaria: [String: Any] = [
    "label":"Bulgaria",
    "value": "bg",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let crotia: [String: Any] = [
    "label":"Croatia",
    "value": "hr",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let czechRepublic: [String: Any] = [
    "label":"Czech Republic",
    "value": "hr",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.driversLicence]
]
let estonia: [String: Any] = [
    "label":"Estonia",
    "value": "ee",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let finland: [String: Any] = [
    "label":"Finland",
    "value": "fi",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.driversLicence]
]
let germany: [String: Any] = [
    "label":"Germany",
    "value": "de",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let hungary: [String: Any] = [
    "label":"Hungary",
    "value": "hu",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let italy: [String: Any] = [
    "label":"Italy",
    "value": "it",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let lithuania: [String: Any] = [
    "label":"Lithuania",
    "value": "lt",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let poland: [String: Any] = [
    "label":"Poland",
    "value": "pl",
    "document_types": [ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let portugal: [String: Any] = [
    "label":"Portugal",
    "value": "pt",
    "document_types": [ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let romania: [String: Any] = [
    "label":"Romania",
    "value": "ro",
    "document_types": [ZippyDocumentType.driversLicence]
]
let slovakia: [String: Any] = [
    "label":"Slovakia",
    "value": "sk",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
let spain: [String: Any] = [
    "label":"Spain",
    "value": "es",
    "document_types": [ZippyDocumentType.idCard, ZippyDocumentType.passport, ZippyDocumentType.driversLicence]
]
