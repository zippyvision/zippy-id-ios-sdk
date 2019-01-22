//
//  TakePhotoVC.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 09/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

protocol TakePhotoVCDelegate: class {
    func onSuccess(vc: TakePhotoVC, image: UIImage)
    func onError(vc: TakePhotoVC, error: ZippyError)
}

class TakePhotoVC: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    let cameraController = CameraController()
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var faceFrameImageView: UIImageView!
    weak var delegate: TakePhotoVCDelegate! = nil
    var mode: ZippyImageMode = .none
    
    @IBAction func onClickTap(_ sender: Any) {
        cameraController.captureImage {[weak self] (image, error) in
            guard let self = self else { return }
            
            self.dismiss(animated: true, completion: {
                if let error = error {
                    self.delegate.onError(vc: self, error: error)
                    return
                }
                
                self.delegate.onSuccess(vc: self, image: image!)
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if delegate == nil {
            self.dismiss(animated: true, completion: nil)
        }
        
        cameraController.prepare { (error) in
            if let error = error {
                self.delegate.onError(vc: self, error: error)
                return
            }
            
            do {
                try self.cameraController.displayPreview(on: self.cameraView)
            } catch let error {
                self.delegate.onError(vc: self, error: ZippyError.cameraWrappedError(error))
                return
            }
            self.adjustCameraMode()
        }
    }
    
    func adjustCameraMode() {
        switch mode {
        case .face:
            switchCameras()
            frameImageView.isHidden = false
            faceFrameImageView.isHidden = true
        case .documentFront:
            frameImageView.isHidden = true
            faceFrameImageView.isHidden = false
        case .documentBack:
            frameImageView.isHidden = false
            faceFrameImageView.isHidden = true
        case .none:
            print("error")
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
