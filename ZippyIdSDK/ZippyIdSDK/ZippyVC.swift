//
//  ZippyVC.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public protocol ZippyViewControllerDelegate {
    func setAvailableCountries(from available: [ZippyCountry]) -> [ZippyCountry]
    func setAvaiableDocumentsForCountry(for country: ZippyCountry, from available: [ZippyDocument]) -> [ZippyDocument]
    func onCompleted(result: ZippyResult)
}

public class ZippyVC: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if !ZippyIdSDK.isInitialized {
            fatalError("Must call `ZippyIdSDK.initialize(key, secret)` before initalizing ZippyVC")
        }
    }
}
