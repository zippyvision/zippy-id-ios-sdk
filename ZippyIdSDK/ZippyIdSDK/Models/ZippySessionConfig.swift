//
//  ZippySessionConfig.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 10/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public struct ZippySessionConfig {
    public var customerId: String
    public var documentType: Document
    
    public init(customerId: String, documentType: Document) {
        self.customerId = customerId
        self.documentType = documentType
    }
}
