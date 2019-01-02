//
//  ZippyIdSDK.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public class ZippyIdSDK {
    static var isInitialized = false
    public static func initialize(key: String, secret: String) {
        isInitialized = true
    }
}
