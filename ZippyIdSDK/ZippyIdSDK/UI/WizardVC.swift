//
//  PreparingVC.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 09/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public enum ZippyImageMode {
    case none
    case face
    case documentFront
    case documentBack
}

class WizardVC: UIViewController {
    @IBOutlet weak var preparingLabel: UILabel!
    @IBOutlet weak var faceImageLabel: UILabel!
    @IBOutlet weak var faceImageDescLabel: UILabel!
    @IBOutlet weak var documentFrontImageLabel: UILabel!
    @IBOutlet weak var documentFrontImageDescLabel: UILabel!
    @IBOutlet weak var documentBackView: UIView!
    @IBOutlet weak var documentBackImageLabel: UILabel!
    @IBOutlet weak var documentBackImageDescLabel: UILabel!
    @IBOutlet weak var sendingLabel: UILabel!
    @IBOutlet weak var helpLabel: UILabel! {
        didSet {
            helpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getHelp(gesture:))))
            helpLabel.isUserInteractionEnabled = true
            formatHelpLabel()
        }
    }
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.isEnabled = false
            button.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var faceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var documentFrontViewHeight: NSLayoutConstraint!
    @IBOutlet weak var documentBackViewHeight: NSLayoutConstraint!
    
    @IBAction func onButtonTap(_ sender: Any) {
        if token == nil {
            button.isEnabled = false
        } else if face == nil {
            button.isEnabled = true
            
            let photoVC = UIStoryboard.init(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC
            
            currentImage = .face
            photoVC.delegate = self
            photoVC.mode = currentImage
            self.present(photoVC, animated: true, completion: nil)
        } else if documentFront == nil {
            button.isEnabled = true

            let photoVC = UIStoryboard.init(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC
            
            currentImage = .documentFront
            photoVC.delegate = self
            photoVC.mode = currentImage
            self.present(photoVC, animated: true, completion: nil)
        } else if documentBack == nil && isPassport != true {
            button.isEnabled = true

            let photoVC = UIStoryboard.init(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "TakePhotoVC") as! TakePhotoVC
            
            currentImage = .documentBack
            photoVC.delegate = self
            photoVC.mode = currentImage
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
    private var currentImage: ZippyImageMode = .none
    
    private var token: String?
    private var face: UIImage?
    private var documentFront: UIImage?
    private var documentBack: UIImage?
    
    var selectedDocument: DocumentType?
    lazy var isPassport = selectedDocument?.value == "passport" ? true : false
    
    var apiClient: ApiClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiClient = ApiClient(secret: ZippyIdSDK.secret, key: ZippyIdSDK.key, baseUrl: ZippyIdSDK.host)
        
        assert(delegate != nil)
        
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
    
    @objc func getHelp(gesture: UITapGestureRecognizer) {
        let helpRange = (helpLabel.text! as NSString).range(of: "Picture example")
        guard gesture.didTapAttributedTextInLabel(label: helpLabel, inRange: helpRange) else { return }
        
        // do something
    }
    
    private func formatHelpLabel() {
        let attributedString = NSMutableAttributedString(string: helpLabel.text ?? "", attributes: nil)
        let helpRange = (helpLabel.text! as NSString).range(of: "Picture example")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: helpRange)
        helpLabel.attributedText = attributedString
    }
    
    func adjustViews(_ enlargeConstraint: NSLayoutConstraint?, _ decreaseConstraint: NSLayoutConstraint?, _ showLabel: UILabel?, _ hideLabel: UILabel?) {
        enlargeConstraint?.constant = 91
        decreaseConstraint?.constant = 41
        showLabel?.isHidden = false
        hideLabel?.isHidden = true
    }
}

extension WizardVC: TakePhotoVCDelegate {
    func onSuccess(vc: TakePhotoVC, image: UIImage) {
        let resized = resizeImage(image: image, newWidth: 1000)
        
        switch currentImage {
        case .face:
            face = resized
            self.faceImageLabel.text! += " OK"
            self.button.setTitle("Uzņemt dokumenta priekšas attēlu", for: .normal)
            adjustViews(documentFrontViewHeight, faceViewHeight, documentFrontImageDescLabel, faceImageDescLabel)
        case .documentFront:
            documentFront = resized
            self.documentFrontImageLabel.text! += " OK"
            self.button.setTitle(isPassport ? "Sūtīt" : "Uzņemt dokumenta aizmugures attēlu", for: .normal)
            adjustViews(documentBackViewHeight, documentFrontViewHeight, documentBackImageDescLabel, documentFrontImageDescLabel)
        case .documentBack:
            if !isPassport {
                documentBack = resized
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

// https://samwize.com/2016/03/04/how-to-create-multiple-tappable-links-in-a-uilabel/
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        
        let step = 10
        return ([-1, 0, 1] * [-1, 0, 1])
            .lazy
            .map { (deltas) -> CGPoint in
                return CGPoint(x: locationOfTouchInTextContainer.x + CGFloat(deltas.0 * step), y: locationOfTouchInTextContainer.y + CGFloat(deltas.1 * step))
            }
            .map({ (locationOfTouch) -> Bool in
                let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouch, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
                
                print("index of char:", indexOfCharacter)
                return NSLocationInRange(indexOfCharacter, targetRange)
            })
            .contains(true)
    }
}

// Descartes product
// https://stackoverflow.com/a/43331492/683763
func *<T1: Sequence, T2: Sequence>(lhs: T1, rhs: T2) -> AnySequence<(T1.Iterator.Element, T2.Iterator.Element)> {
    return AnySequence (
        lhs.lazy.flatMap { x in rhs.lazy.map { y in (x, y) }}
    )
}
