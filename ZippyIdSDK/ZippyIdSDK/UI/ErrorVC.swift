//
//  ErrorVC.swift
//  ZippyIdSDK
//
//  Created by Melānija Grunte on 09/07/2019.
//

import UIKit
import Foundation

protocol RetryDelegate: class {
    func onRetryCallback(vc: ErrorVC, verification: ZippyVerification)
}

class ErrorVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton! {
        didSet {
            retryButton.layer.cornerRadius = 20
        }
    }
    
    public weak var retryDelegate: RetryDelegate!
    var zippyVerification: ZippyVerification!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Reason: " + (zippyVerification.error ?? "unknown")
    }
    
    @IBAction func onRetryTap(_ sender: UIButton) {        
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.retryDelegate.onRetryCallback(vc: self, verification: self.zippyVerification)
        })
    }
}
