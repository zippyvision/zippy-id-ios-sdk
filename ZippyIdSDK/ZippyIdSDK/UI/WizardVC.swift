//
//  PreparingVC.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 09/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

protocol NextPhotoStep: class {
    func onAccept(vc: PhotoConfirmationVC, image: UIImage)
    func onError(vc: TakePhotoVC, error: ZippyError)
}

public enum ZippyImageMode {
    case none
    case face
    case documentFront
    case documentBack
}

class WizardVC: UIViewController, URLSessionTaskDelegate {
    @IBOutlet weak var preparingLabel: UILabel!
    @IBOutlet weak var faceImageLabel: UILabel!
    @IBOutlet weak var faceImageDescLabel: UILabel!
    @IBOutlet weak var documentFrontImageLabel: UILabel!
    @IBOutlet weak var documentFrontImageDescLabel: UILabel!
    @IBOutlet weak var documentBackView: UIView!
    @IBOutlet weak var documentBackImageLabel: UILabel!
    @IBOutlet weak var documentBackImageDescLabel: UILabel!
    @IBOutlet weak var sendingLabel: UILabel!
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.isEnabled = false
            button.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var faceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var documentFrontViewHeight: NSLayoutConstraint!
    @IBOutlet weak var documentBackViewHeight: NSLayoutConstraint!
        
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressPercentageLabel: UILabel! {
        didSet {
            progressPercentageLabel.text = "0%"
        }
    }
    
    @IBAction func onButtonTap(_ sender: Any) {
        let bundle = Bundle(for: ZippyVC.self)
        
        if token == nil {
            button.isEnabled = false
        } else if face == nil {
            button.isEnabled = true
            
            let photoVC = UIStoryboard.init(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC
            
            currentImage = .face
            photoVC.mode = currentImage
            photoVC.documentType = selectedDocument
            photoVC.delegate = self.delegate
            photoVC.nextPhotoStepDelegate = self
            self.present(photoVC, animated: true, completion: nil)
        } else if documentFront == nil {
            button.isEnabled = true

            let photoVC = UIStoryboard.init(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC
            
            currentImage = .documentFront
            photoVC.mode = currentImage
            photoVC.documentType = selectedDocument
            photoVC.delegate = self.delegate
            photoVC.nextPhotoStepDelegate = self
            self.present(photoVC, animated: true, completion: nil)
        } else if documentBack == nil && isPassport != true {
            button.isEnabled = true

            let photoVC = UIStoryboard.init(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC
            
            currentImage = .documentBack
            photoVC.mode = currentImage
            photoVC.documentType = selectedDocument
            photoVC.delegate = self.delegate
            photoVC.nextPhotoStepDelegate = self
            self.present(photoVC, animated: true, completion: nil)
        } else {
            button.isEnabled = false
            
            send()
        }
    }
    
    public weak var delegate: ZippyVCDelegate!
    public weak var zippyCallback: ZippyCallback?
    weak var nextPhotoStepDelegate: NextPhotoStep! = nil
    
    private let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    private let decoder = JSONDecoder()
    
    private var configuration: ZippySessionConfig! = nil
    private var currentImage: ZippyImageMode = .none
    
    private var token: String?
    private var face: UIImage?
    private var documentFront: UIImage?
    private var documentBack: UIImage?
    
    lazy var selectedDocument: DocumentType = DocumentType(value: "ID card", label: "id_card")
    lazy var isPassport = selectedDocument.value == "passport" ? true : false
    
    var apiClient: ApiClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiClient = ApiClient(secret: ZippyIdSDK.secret, key: ZippyIdSDK.key, baseUrl: ZippyIdSDK.host)
        
        assert(delegate != nil)
        
        apiClient.session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: OperationQueue.main)
        configuration = delegate.getSessionConfiguration()
        
        if isPassport {
            documentBackView.removeFromSuperview()
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
                        self.adjustViews(self.faceViewHeight, nil, self.faceImageDescLabel, nil)
                    }
                }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        progressView.progress = uploadProgress
        let progressPercent = Int(uploadProgress*100)
        progressPercentageLabel.text = "\(progressPercent)%"
    }
    
    private func send() {
        progressView.isHidden = false
        progressPercentageLabel.isHidden = false
        apiClient.sendImages(token: token!, documentType: configuration.documentType, selfie: face!, documentFront: documentFront!, documentBack: documentBack, customerUid: configuration.customerId)
            .observe { (result) in
                switch result {
                case .error:
                    ()
                case .value(let id):
                    print("Submited with ID = \(id)")
                    
                    DispatchQueue.main.async {
                        self.sendingLabel.text! += " OK"
                        self.zippyCallback?.onSubmit()
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
                        self.zippyCallback?.onFinished()
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
    
    func adjustViews(_ enlargeConstraint: NSLayoutConstraint?, _ decreaseConstraint: NSLayoutConstraint?, _ showLabel: UILabel?, _ hideLabel: UILabel?) {
        enlargeConstraint?.constant = 91
        decreaseConstraint?.constant = 41
        showLabel?.isHidden = false
        hideLabel?.isHidden = true
    }
}

extension WizardVC: NextPhotoStep {
    func onAccept(vc: PhotoConfirmationVC, image: UIImage) {
        switch currentImage {
        case .face:
            face = image
            self.faceImageLabel.text! += " OK"
            self.button.setTitle("Uzņemt dokumenta priekšas attēlu", for: .normal)
            adjustViews(documentFrontViewHeight, faceViewHeight, documentFrontImageDescLabel, faceImageDescLabel)
        case .documentFront:
            documentFront = image
            self.documentFrontImageLabel.text! += " OK"
            self.button.setTitle(isPassport ? "Sūtīt" : "Uzņemt dokumenta aizmugures attēlu", for: .normal)
            adjustViews(documentBackViewHeight, documentFrontViewHeight, documentBackImageDescLabel, documentFrontImageDescLabel)
        case .documentBack:
            if !isPassport {
                documentBack = image
                self.documentBackImageLabel.text! += " OK"
                self.button.setTitle("Sūtīt", for: .normal)
                adjustViews(nil, documentBackViewHeight, nil, documentBackImageDescLabel)
            }
        default:
            ()
        }
        
        currentImage = .none
    }
    
    func onError(vc: TakePhotoVC, error: ZippyError) {
        currentImage = .none
        
        delegate.onCompletedWithError(error: error)
    }
}
