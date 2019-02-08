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
    weak var nextPhotoStepDelegate: NextPhotoStep! = nil
    var mode: ZippyImageMode = .none
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustForMode()
        
        if ((mode == .documentFront) || mode == .documentBack ) {
            image = image?.rotateImage(radians: -.pi/2)
            let ratio = image!.size.width / image!.size.height
            let newHeight = photoImageView.frame.width / ratio
            photoImageView.frame.size = CGSize(width: photoImageView.frame.width, height: newHeight)
        }
        
        image = image?.resizeImage(newWidth: 1000)
        self.photoImageView.image = image
    }
    
    func adjustForMode() {
        switch mode {
        case .face:
            descriptionLabel.text = "Make sure your face is recognizable, with no blur or glare"
            isReadableButton.setTitle("My face is recognizable", for: .normal)
        case .documentFront, .documentBack:
            descriptionLabel.text = "Make sure your license details are clear to read, with no blur or glare"
            isReadableButton.setTitle("My license ir readable", for: .normal)
        case .none:
            print("error")
        }
    }
    

    @IBAction func confirmPhoto(_ sender: UIButton) {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.nextPhotoStepDelegate.onAccept(vc: self, image: self.image!)
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
    
    func rotateImage(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

