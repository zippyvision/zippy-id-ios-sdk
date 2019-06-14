//
//  ZippyVC.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public protocol ZippyCallback: class {
    func onSubmit()
    func onTextExtracted()
    func onFinished()
}

public protocol ZippyVCDelegate: class {
    func getSessionConfiguration() -> ZippySessionConfig
    func onCompletedSuccessfully(result: ZippyResult)
    func onCompletedWithError(error: ZippyError)
}

public class ZippyVC: UIViewController {
    public weak var delegate: ZippyVCDelegate!
    public weak var zippyCallback: ZippyCallback?
    var wizardVC: WizardVC!
    var idVertificationVC: IDVertificationVC!
    let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    var customerUid: Int?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if !ZippyIdSDK.isInitialized {
            fatalError("Must call `ZippyIdSDK.initialize(apiKey)` before initalizing ZippyVC")
        }
        
        if delegate == nil {
            fatalError("Must pass a delegate to the ZippyVC")
        }
        
        DispatchQueue.main.async {
            let bundle = Bundle(for: ZippyVC.self)
            self.idVertificationVC = (UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "IDVertificationVC") as! IDVertificationVC)
            self.idVertificationVC.delegate = self.delegate
            self.idVertificationVC.zippyCallback = self.zippyCallback
            self.present(self.idVertificationVC, animated: false, completion: nil)
        }
    }
}
