//
//  TakePhotoVC.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 09/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

class TakePhotoVC: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var faceFrameStackView: UIStackView!
    @IBOutlet weak var documentFrontFrameStackView: UIStackView!
    @IBOutlet weak var documentBackFrameStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public weak var delegate: ZippyVCDelegate!
    weak var nextPhotoStepDelegate: NextPhotoStep! = nil
    let cameraController = CameraController()
    var mode: ZippyImageMode = .none
    var document: Document!
    var timer = Timer()
    
    @IBAction func onClickTap(_ sender: Any) {
        capturePhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if nextPhotoStepDelegate == nil {
            self.dismiss(animated: true, completion: nil)
        }
        
        cameraController.prepare { (error) in
            if let error = error {
                self.nextPhotoStepDelegate.onError(vc: self, error: ZippyError.cameraWrappedError(error))
                return
            }
            
            do {
                try self.cameraController.displayPreview(on: self.cameraView)
            } catch let error {
                self.nextPhotoStepDelegate.onError(vc: self, error: ZippyError.cameraWrappedError(error))
                return
            }
            
            self.adjustCameraMode()
            self.cameraController.mode = self.mode
            self.scheduledTimerWithTimeInterval()
        }
    }
    
    func capturePhoto() {
        cameraController.captureImage {[weak self] (image, error) in
            guard let self = self, image != nil else { return }
            
            let bundle = Bundle(for: ZippyVC.self)
            
            let photoConfirmationVC = UIStoryboard.init(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "PhotoConfirmationVC") as! PhotoConfirmationVC
            
            photoConfirmationVC.image = image
            photoConfirmationVC.delegate = self.delegate
            photoConfirmationVC.nextPhotoStepDelegate = self.nextPhotoStepDelegate
            photoConfirmationVC.mode = self.mode
            photoConfirmationVC.document = self.document
            self.present(photoConfirmationVC, animated: true, completion: nil)
        }
    }
    
    func adjustCameraMode() {
        switch mode {
        case .face:
            switchCameras()
            faceFrameStackView.isHidden = false
            documentFrontFrameStackView.isHidden = true
            documentBackFrameStackView.isHidden = true
            titleLabel.text = ""
            descriptionLabel.text = ""
        case .documentFront:
            faceFrameStackView.isHidden = true
            documentFrontFrameStackView.isHidden = false
            documentBackFrameStackView.isHidden = true
            titleLabel.text = document.translation
            if (document == .passport) {
                descriptionLabel.text = "Position your passport in the frame"
            } else {
                descriptionLabel.text = "Position the front of your \(document.translation) in the frame"
            }
        case .documentBack:
            faceFrameStackView.isHidden = true
            documentFrontFrameStackView.isHidden = true
            documentBackFrameStackView.isHidden = false
            titleLabel.text = document.translation
            descriptionLabel.text = "Position the back of your \(document.translation) in the frame"
        case .none:
            print("error")
        }
    }
    
    func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.searchObject), userInfo: nil, repeats: true)
    }
    
    @objc func searchObject() {
        if (self.cameraController.objectDetected) {
            self.capturePhoto()
            timer.invalidate()
        }
    }
    
    func switchCameras() {
        do {
            try cameraController.switchCameras()
        } catch {
            print(error)
        }
    }
}
