//
//  DocumentTranslations.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 13/06/2019.
//

import Foundation

extension Document {
    var translation: String {
        switch self {
        case .driversLicense:
            return "Driver's license"
        case .idCard:
            return "ID card"
        case .passport:
            return "Passport"
        case .unknown:
            return "-"
        }
    }
}
