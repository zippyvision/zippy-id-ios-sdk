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
    static private(set) var key: String!
    static private(set) var secret: String!
    static private(set) var customerUid: Int?
    
    public static func initialize(key: String, secret: String, customerUid: Int?) {
        self.key = key
        self.secret = secret
        self.customerUid = customerUid
        isInitialized = true
    }
}
