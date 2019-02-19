//
//  ZippyError.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public enum ZippyError: Error {
    case processingTimedOut
    case processingFailed
    
    case imageSendingFailed
    
    case cameraCaptureSessionAlreadyRunning
    case cameraCaptureSessionIsMissing
    case cameraInputsAreInvalid
    case cameraInvalidOutput
    case cameraInvalidOperation
    case cameraNoCamerasAvailable
    case cameraWrappedError(Error)
    case cameraUnknown
    
    case otherError(Error?)
}
