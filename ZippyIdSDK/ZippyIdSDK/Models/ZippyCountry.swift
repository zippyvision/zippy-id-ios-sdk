//
//  ZippyCountry.swift
//  ZippyIdSDK
//
//  Created by Melānija Grunte on 16/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public enum Document: String, Codable {
    case idCard = "ID card"
    case passport = "Passport"
    case driversLicense = "Driver's license"
    case unknown = ""
    
    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case label = "label"
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try! decoder.container(keyedBy: CodingKeys.self)
        let typeValue = String(try container.decode(String.self, forKey: .value))
        switch typeValue {
        case "id_card":
            self = .idCard
        case "passport":
            self = .passport
        case "drivers_license":
            self = .driversLicense
        default:
            self = .unknown
        }
    }
}

struct Country: Decodable {
    let value: String
    let label: String
    let documents: [Document]
    
    private enum CodingKeys: String, CodingKey {
        case value, label, documents = "document_types"
    }
}
