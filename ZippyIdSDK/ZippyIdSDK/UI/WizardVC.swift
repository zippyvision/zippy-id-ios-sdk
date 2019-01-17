//
//  PreparingVC.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 09/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

class WizardVC: UIViewController {
    @IBOutlet weak var preparingLabel: UILabel!
    @IBOutlet weak var faceImageLabel: UILabel!
    @IBOutlet weak var documentFrontImageLabel: UILabel!
    @IBOutlet weak var documentBackImageLabel: UILabel!
    @IBOutlet weak var sendingLabel: UILabel!
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.isEnabled = false
        }
    }
    @IBAction func onButtonTap(_ sender: Any) {
        if token == nil {
            button.isEnabled = false
        } else if face == nil {
            button.isEnabled = true
            
            let photoVC = UIStoryboard.init(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC
            
            currentImage = "face"
            
            photoVC.delegate = self
            
            self.present(photoVC, animated: true, completion: nil)
        } else if documentFront == nil {
            button.isEnabled = true

            let photoVC = UIStoryboard.init(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC

            currentImage = "documentFront"

            photoVC.delegate = self

            self.present(photoVC, animated: true, completion: nil)
        } else if (documentBack == nil && isPassport != true) {
            button.isEnabled = true

            let photoVC = UIStoryboard.init(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC

            currentImage = "documentBack"

            photoVC.delegate = self

            self.present(photoVC, animated: true, completion: nil)
        } else {
            button.isEnabled = false
            
            send()
        }
    }
    
    public weak var delegate: ZippyVCDelegate!
    
    private let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    private let decoder = JSONDecoder()
    
    private var configuration: ZippySessionConfig! = nil
    private var currentImage: String = "none"
    
    private var token: String?
    private var face: UIImage?
    private var documentFront: UIImage?
    private var documentBack: UIImage?
    
    var selectedDocument: ZippyDocumentType?
    lazy var isPassport = selectedDocument == ZippyDocumentType.passport ? true : false
    
    var apiClient: ApiClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiClient = ApiClient(secret: ZippyIdSDK.secret, key: ZippyIdSDK.key, baseUrl: ZippyIdSDK.host)
        
        assert(delegate != nil)
        
        configuration = delegate.getSessionConfiguration()
        
        if isPassport {
            documentBackImageLabel.removeFromSuperview()
        }
        
        apiClient.getToken()
            .observe { (result) in
                switch result {
                case .error:
                    ()
                case .value(let token):
                    self.token = token
        
                    DispatchQueue.main.async {
                        self.preparingLabel.text! += " OK"
                        self.button.isEnabled = true
                        self.button.setTitle("Uzņemt sejas attēlu", for: .normal)
                    }
                }
            }
    }
    
    private func send() {
        apiClient.sendImages(token: token!, documentType: configuration.documentType, selfie: face!, documentFront: documentFront!, documentBack: documentBack, customerUid: configuration.customerId)
            .observe { (result) in
                switch result {
                case .error:
                    ()
                case .value(let id):
                    print("Submited with ID = \(id)")
                    
                    DispatchQueue.main.async {
                        self.sendingLabel.text! += " OK"
        
                        self.pollJobStatus()
                    }
                }
            }
    }
    
    var count = 0
    private func pollJobStatus() {
        print("Trying to get status: \(count)")
        
        if self.count == 10 {
            self.dismiss(animated: true, completion: nil)
            self.delegate.onCompletedWithError(error: .processingTimedOut)
            return
        }
        
        apiClient
            .getJobStatus(customerId: configuration.customerId)
            .observe { (result) in
                switch result {
                case .error(let err):
                    print(err)
                    self.count += 1
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
                        self.pollJobStatus()
                    })
                case .value(let result):
                    if result.state == .finished {
                        self.dismiss(animated: true, completion: nil)
                        self.delegate.onCompletedSuccessfully(result: result)
                    } else if result.state == .failed {
                        self.dismiss(animated: true, completion: nil)
                        self.delegate.onCompletedWithError(error: ZippyError.processingFailed)
                    } else {
                        print("Scheduling poll")
                        self.count += 1
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
                            self.pollJobStatus()
                        })
                    }
                }
            }
    }
}

extension WizardVC: TakePhotoVCDelegate {
    func onSuccess(vc: TakePhotoVC, image: UIImage) {
        let resized = resizeImage(image: image, newWidth: 1000)
        
        switch currentImage {
        case "face":
            face = resized
            self.faceImageLabel.text! += " OK"
            self.button.setTitle("Uzņemt dokumenta priekšas attēlu", for: .normal)
        case "documentFront":
            documentFront = resized
            self.documentFrontImageLabel.text! += " OK"
            self.button.setTitle(isPassport ? "Sūtīt" : "Uzņemt dokumenta aizmugures attēlu", for: .normal)
        case "documentBack":
            if !isPassport {
                documentBack = resized
                self.documentBackImageLabel.text! += " OK"
                self.button.setTitle("Sūtīt", for: .normal)
            }
        default:
            ()
        }
        
        currentImage = "none"
    }
    
    func onError(vc: TakePhotoVC, error: ZippyError) {
        currentImage = "none"
        
        delegate.onCompletedWithError(error: error)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
