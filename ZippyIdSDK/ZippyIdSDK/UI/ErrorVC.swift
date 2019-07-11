//
//  ErrorVC.swift
//  ZippyIdSDK
//
//  Created by Melānija Grunte on 09/07/2019.
//

import UIKit
import Foundation

class ErrorVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    public weak var delegate: ZippyVCDelegate!
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
