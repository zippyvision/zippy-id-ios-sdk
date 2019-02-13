//
//  ViewController.swift
//  ZippyIdSDKDemo
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import UIKit
import ZippyIdSDK

class ViewController: UIViewController {
    @IBAction func onButtonTap(_ sender: Any) {
        let vc = ZippyVC()
        vc.delegate = self
        vc.zippyCallback = self
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController: ZippyVCDelegate {
    func onCompletedSuccessfully(result: ZippyResult) {
        print(result)
    }
    
    func onCompletedWithError(error: ZippyError) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getSessionConfiguration() -> ZippySessionConfig {
        return ZippySessionConfig(customerId: "\(Date().timeIntervalSince1970)", documentType: .driversLicence)
    }
}

extension ViewController: ZippyCallback {
    func onSubmit() {
        // fired, tad kad ir uploadotas visas bildes
    }
    func onTextExtracted() {
        // fired, tad kad API end-pointā parādās rezultāts ( iedošu endpoint )
    }
    func onFinished() {
        // fired, tad kad visi checki veikti (API end point jau it kā ir, bet uztaisīšu mazliet sakarīgāku)
    }
}

