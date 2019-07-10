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
    public weak var nextStepDelegate: NextStepDelegate! = nil
    var zippyVerification: ZippyVerification!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Reason: " + (zippyVerification.error ?? "unknown")
    }
    
    @IBAction func onRetryTap(_ sender: UIButton) {
        let bundle = Bundle(for: ZippyVC.self)
        let wizardVC = UIStoryboard.init(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "WizardVC") as! WizardVC
        wizardVC.delegate = self.delegate
        
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.nextStepDelegate.onRetryCallback(vc: self, verification: self.zippyVerification)
        })
    }
}
