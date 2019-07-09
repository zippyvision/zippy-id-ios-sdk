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
        ZippyIdSDK.initialize(apiKey: "96d648cb194cd2e085cff4c2c2860ae7d83984398ab8020e66782116e4ab4d01bb900a73e86bf5fa")
        return true
    }
}
