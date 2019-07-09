//
//  ZippyVerificationProgress.swift
//  Pods-ZippyIdSDKDemo
//
//  Created by Melānija Grunte on 08/07/2019.
//

import Foundation

public struct ZippyVerification: Codable {
    public var state: ZippyVerificationState?
    public var error: String?
    public var requestToken: String?
    
    private enum CodingKeys: String, CodingKey {
        case state, error, requestToken = "request_token"
    }
}

public enum ZippyVerificationState: String, Codable {
    case success = "success"
    case failed = "failed"
    case inProgress = ""
    
    public init(from decoder: Decoder) throws {
        let valueContainer: SingleValueDecodingContainer = try! decoder.singleValueContainer()
        let val: String? = try! valueContainer.decode(String.self)
        self = ZippyVerificationState(rawValue: val!) ?? .inProgress
    }
}
