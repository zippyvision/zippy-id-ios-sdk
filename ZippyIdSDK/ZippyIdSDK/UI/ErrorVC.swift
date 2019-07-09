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
    var selectedDocument: Document!
    var zippyVerification: ZippyVerification!
    public weak var zippyCallback: ZippyCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Reason: " + (zippyVerification.error ?? "unknown")
    }
    
    @IBAction func onRetryTap(_ sender: UIButton) {
        let bundle = Bundle(for: ZippyVC.self)
        let wizardVC = UIStoryboard.init(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "WizardVC") as! WizardVC
        wizardVC.delegate = self.delegate
        wizardVC.selectedDocument = selectedDocument!
        wizardVC.zippyCallback = self.zippyCallback
        wizardVC.apiClient = ApiClient(apiKey: zippyVerification.requestToken!, baseUrl: ZippyIdSDK.host)
        
        weak var presentingViewController = self.presentingViewController
        self.dismiss(animated: true, completion: {
            presentingViewController?.present(wizardVC, animated: false, completion: nil)
        })
    }
}
