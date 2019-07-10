//
//  PhotoConfirmationVC.swift
//  ZippyIdSDK
//
//  Created by Melānija Grunte on 07/02/2019.
//

import Foundation

class PhotoConfirmationVC: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var isReadableButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    public weak var delegate: ZippyVCDelegate!
    private var configuration: ZippySessionConfig! = nil
    public weak var nextStepDelegate: NextStepDelegate! = nil
    var mode: ZippyImageMode = .none
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration = delegate.getSessionConfiguration()
        
        adjustForMode()
        
        image = image?.resizeImage(newWidth: 1000)
        self.photoImageView.image = image
    }
    
    func adjustForMode() {
        let documentTypeLabel: String = (configuration.documentType == .idCard) ? configuration.documentType.translation : configuration.documentType.translation.lowercased()
        
        switch mode {
        case .face:
            descriptionLabel.text = "Make sure your face is recognizable, with no blur or glare"
            isReadableButton.setTitle("My face is recognizable", for: .normal)
        case .documentFront, .documentBack:
            descriptionLabel.text = "Make sure your \(documentTypeLabel) details are clear to read, with no blur or glare"
            isReadableButton.setTitle("My \(documentTypeLabel) ir readable", for: .normal)
        case .none:
            print("error")
        }
    }
    

    @IBAction func confirmPhoto(_ sender: UIButton) {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.nextStepDelegate.onAccept(vc: self, image: self.image!)
        })
    }

    @IBAction func takeNewPhoto(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

