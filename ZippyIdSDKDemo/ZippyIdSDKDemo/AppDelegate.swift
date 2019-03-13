//
//  AppDelegate.swift
//  ZippyIdSDKDemo
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import UIKit
import ZippyIdSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ZippyIdSDK.initialize(key: "db32a431113a3ecc2f322c5a42dfb9b454e83ece5d78a83815373885070c7d75d41f3012b64d30b3", secret: "0e1f18ff5fca8a9f0d971dd0b8e0dce0")
        return true
    }
}
