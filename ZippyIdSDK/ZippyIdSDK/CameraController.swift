//
//  CameraController.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 10/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

// https://www.appcoda.com/avfoundation-swift-guide/

import AVFoundation

class CameraController: NSObject {
    var captureSession: AVCaptureSession?
    
    var currentCameraPosition: CameraPosition?
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var output: AVCaptureVideoDataOutput?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, ZippyError?) -> Void)?
    
    var objectDetected: Bool = false
}

@available(iOS 10.0, *)
extension CameraController {
    func prepare(completionHandler: @escaping (ZippyError?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func setFocus(_ camera: AVCaptureDevice) throws {
            if (camera.isFocusModeSupported(.continuousAutoFocus)) {
                try camera.lockForConfiguration()
                camera.focusMode = .continuousAutoFocus
                camera.unlockForConfiguration()
            }
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = session.devices
            guard !cameras.isEmpty else { throw ZippyError.cameraNoCamerasAvailable }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                    try setFocus(camera)
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    try setFocus(camera)
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw ZippyError.cameraCaptureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
                
                self.currentCameraPosition = .rear
            } else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) {
                    captureSession.addInput(self.frontCameraInput!)
                } else {
                    throw ZippyError.cameraInputsAreInvalid
                }
                
                self.currentCameraPosition = .front
            } else {
                throw ZippyError.cameraNoCamerasAvailable
            }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw ZippyError.cameraCaptureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.output = AVCaptureVideoDataOutput()
            
            if let output = self.output {
                output.alwaysDiscardsLateVideoFrames = true
                let outputQueue = DispatchQueue(label: "outputQueue")
                output.setSampleBufferDelegate(self, queue: outputQueue)
                if (captureSession.canAddOutput(output)) {
                    captureSession.addOutput(output)
                } else {
                    throw ZippyError.cameraInvalidOutput
                }

            }
            
            if #available(iOS 11.0, *) {
                self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            } else {
                self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])], completionHandler: nil)
            }
            
            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(ZippyError.cameraWrappedError(error))
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw ZippyError.cameraCaptureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw ZippyError.cameraCaptureSessionIsMissing }
        
        captureSession.beginConfiguration()
        
        func switchToFrontCamera() throws {
            
            guard let rearCameraInput = self.rearCameraInput, captureSession.inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else { throw ZippyError.cameraInvalidOperation }
            
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            } else {
                throw ZippyError.cameraInvalidOperation
            }
        }
        
        func switchToRearCamera() throws {
            
            guard let frontCameraInput = self.frontCameraInput, captureSession.inputs.contains(frontCameraInput),
                let rearCamera = self.rearCamera else { throw ZippyError.cameraInvalidOperation }
            
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
                
                self.currentCameraPosition = .rear
            } else {
                throw ZippyError.cameraInvalidOperation
            }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .rear:
            try switchToFrontCamera()
        }
        
        captureSession.commitConfiguration()
    }
    
    func captureImage(completion: @escaping (UIImage?, ZippyError?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, ZippyError.cameraCaptureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {

            let cameraImage = CIImage(cvPixelBuffer: pixelBuffer)
            let accuracy = [ CIDetectorAccuracy : CIDetectorAccuracyHigh ]
            
            if (self.currentCameraPosition == CameraPosition.front) {
                let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
                if let faces = faceDetector?.features(in: cameraImage) as? [CIFaceFeature] {
                    objectDetected = faces.filter{!$0.leftEyeClosed && !$0.rightEyeClosed}.count > 0
                }
            } else if (self.currentCameraPosition == CameraPosition.rear) {
                let rectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: accuracy)
                if let rectangles = rectangleDetector?.features(in: cameraImage) as? [CIRectangleFeature] {
                    objectDetected = rectangles.count > 0
                }
            }
        }
    }
    
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error {
            self.photoCaptureCompletionBlock?(nil, ZippyError.cameraWrappedError(error))
        } else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil), let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
        } else {
            self.photoCaptureCompletionBlock?(nil, ZippyError.cameraUnknown)
        }
    }
}

extension CameraController {
    public enum CameraPosition {
        case front
        case rear
    }
}
