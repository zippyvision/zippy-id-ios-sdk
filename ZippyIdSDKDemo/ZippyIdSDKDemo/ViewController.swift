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
        
        self.present(vc, animated: true, completion: nil)
    }
}
