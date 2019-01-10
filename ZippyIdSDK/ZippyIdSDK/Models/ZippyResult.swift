//
//  ZippyResult.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 02/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

public enum ZippyResponseState: String, Codable {
    case processing = "processing"
    case finished = "finished"
    case failed = "failed"
    case unknown = "unknown"
    
    public init(from decoder: Decoder) throws {
        let a: SingleValueDecodingContainer = try! decoder.singleValueContainer()
        let val: String? = try! a.decode(String.self)
        
        self = ZippyResponseState(rawValue: val!) ?? .unknown
    }
}

public enum ZippyImageType: String, Codable {
    case selfie = "selfie"
    case id_front = "id_front"
    case id_back = "id_back"
    case payslip = "payslip"
    case proof_of_residence = "proof_of_residence"
    case unknown = "unknown"
    
    
    public init(from decoder: Decoder) throws {
        let a: SingleValueDecodingContainer = try! decoder.singleValueContainer()
        let val: String? = try! a.decode(String.self)
        
        self = ZippyImageType(rawValue: val!) ?? .unknown
    }
}

public struct ZippyResult: Codable {
    public var created_at: String
    public var customerData: ZippyCustomerData?
    public var finished_at: String?
    public var state: ZippyResponseState?
    public var processing_errors: [String: [String]]
    
    /*
     Can't use enum here because of
     https://forums.swift.org/t/json-encoding-decoding-weird-encoding-of-dictionary-with-enum-values/12995/8
     public var images: [ZippyImageType: String?]
     */
    public var images: [String: String?]
    //    "face_similarity": null,
    //    "similar_faces": {},
    //    "face_id": null
}
