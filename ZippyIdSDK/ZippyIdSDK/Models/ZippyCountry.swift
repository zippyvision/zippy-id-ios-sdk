//
//  ZippyCountry.swift
//  ZippyIdSDK
//
//  Created by Melānija Grunte on 16/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public struct DocumentType: Decodable {
    let value: String
    let label: String
}

struct Country: Decodable {
    let value: String
    let label: String
    let documentTypes: [DocumentType]
    
    private enum CodingKeys: String, CodingKey {
        case value, label, documentTypes = "document_types"
    }
}
