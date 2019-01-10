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
    
    
    case cameraCaptureSessionAlreadyRunning
    case cameraCaptureSessionIsMissing
    case cameraInputsAreInvalid
    case cameraInvalidOperation
    case cameraNoCamerasAvailable
    case cameraWrappedError(Error)
    case cameraUnknown
}
