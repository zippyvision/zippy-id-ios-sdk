//
//  ZippyIdSDK.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public class ZippyIdSDK {
    static let host = "https://demo.zippyid.com/api/"
    
    static var isInitialized = false
    static private(set) var apiKey: String!
    
    public static func initialize(apiKey: String) {
        self.apiKey = apiKey
        isInitialized = true
    }
}
