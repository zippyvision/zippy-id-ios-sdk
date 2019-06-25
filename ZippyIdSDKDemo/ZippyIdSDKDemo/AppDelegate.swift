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
        ZippyIdSDK.initialize(apiKey: "a9adc0e08ccf68a7427a09612c046e17fbc9564bbc5712df9435dc3c67af579b059aa2f016e779a2")
        return true
    }
}
