//
//  ZippyVC.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public protocol ZippyVCDelegate: class {
    func getSessionConfiguration() -> ZippySessionConfig
    func onCompletedSuccessfully(result: ZippyResult)
    func onCompletedWithError(error: ZippyError)
}

public class ZippyVC: UIViewController {
    public weak var delegate: ZippyVCDelegate!
    var wizardVC: WizardVC!
    var idVertificationVC: IDVertificationVC!
    let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if !ZippyIdSDK.isInitialized {
            fatalError("Must call `ZippyIdSDK.initialize(key, secret)` before initalizing ZippyVC")
        }
        
        if delegate == nil {
            fatalError("Must pass a delegate to the ZippyVC")
        }
        
        DispatchQueue.main.async {
            self.idVertificationVC = (UIStoryboard(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "IDVertificationVC") as! IDVertificationVC)
            self.idVertificationVC.delegate = self.delegate
            self.present(self.idVertificationVC, animated: false, completion: nil)
        }
    }
}
