//
//  ZippySessionConfig.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 10/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public enum ZippyDocumentType: String {
    case passport = "passport"
    case idCard = "id_card"
    case driversLicence = "drivers_licence"
}

public struct ZippySessionConfig {
    public var customerId: String
    public var documentType: ZippyDocumentType
    
    public init(customerId: String, documentType: ZippyDocumentType) {
        self.customerId = customerId
        self.documentType = documentType
    }
}
