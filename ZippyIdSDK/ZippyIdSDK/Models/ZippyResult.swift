//
//  ZippyResult.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public enum ZippyResponseState: String, Codable {
    case processing
    case finished
    case failed
    case unknown
    
    public init(from decoder: Decoder) throws {
        let valueContainer: SingleValueDecodingContainer = try! decoder.singleValueContainer()
        let val: String? = try! valueContainer.decode(String.self)
        
        self = ZippyResponseState(rawValue: val!) ?? .unknown
    }
}

public enum ZippyImageType: String, Codable {
    case selfie
    case idFront = "id_front"
    case idBack = "id_back"
    case payslip
    case proofOfResidence = "proof_of_residence"
    case unknown
    
    public init(from decoder: Decoder) throws {
        let valueContainer: SingleValueDecodingContainer = try! decoder.singleValueContainer()
        let val: String? = try! valueContainer.decode(String.self)
        
        self = ZippyImageType(rawValue: val!) ?? .unknown
    }
}

public struct ZippyResult: Codable {
    public var createdAt: String
    public var customerData: ZippyCustomerData?
    public var finishedAt: String?
    public var state: ZippyResponseState?
    public var processingErrors: [String: [String]]?
    
    /*
     Can't use enum here because of
     https://forums.swift.org/t/json-encoding-decoding-weird-encoding-of-dictionary-with-enum-values/12995/8
     public var images: [ZippyImageType: String?]
     */
    public var images: [String: String?]
    //    "face_similarity": null,
    //    "similar_faces": {},
    //    "face_id": null
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at", customerData, finishedAt = "finished_at", state, processingErrors = "processing_errors", images
    }
}
