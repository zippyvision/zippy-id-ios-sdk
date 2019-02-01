//
//  ApiClient.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 10/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

class ApiClient {
    let secret: String
    let key: String
    let baseUrl: String
    var session: URLSession = URLSession(configuration: .ephemeral)
    let decoder = JSONDecoder()
    
    init(secret: String, key: String, baseUrl: String) {
        self.secret = secret
        self.key = key
        self.baseUrl = baseUrl
    }
    
    func getToken() -> Future<String> {
        let url: URL = URL(string: baseUrl)!
            .appendingPathComponent("v1")
            .appendingPathComponent("request_tokens")
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "api_key=\(key)&secret_key=\(secret)".data(using: .utf8)
        
        return session
            .request(request: request)
            .transformed(with: { (data) -> String in
                let json: [String: String] = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                return json["token"]!
            })
    }
    
    func sendImages(token: String, documentType: ZippyDocumentType, selfie: UIImage, documentFront: UIImage, documentBack: UIImage?, customerUid: String) -> Future<String> {
        let url: URL = URL(string: baseUrl)!
            .appendingPathComponent("v1")
            .appendingPathComponent("verifications")
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        let postBody: [String: String] = [
            "token": token,
            "document_country": "lv",
            "document_type": documentType.rawValue,
            "image_data[selfie]": "data:image/png;base64," + convertToFormParam(image: selfie),
            "image_data[idFront]": "data:image/png;base64," + convertToFormParam(image: documentFront),
            "image_data[idBack]": ((documentBack != nil) ? "data:image/png;base64," + convertToFormParam(image: documentBack!) : "no image"),
            "customer_uid": customerUid,
        ]
        let postBodyString: String = postBody
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        request.httpBody = postBodyString.data(using: .utf8)
        
        return session
            .request(request: request)
            .transformed(with: { (data) -> String in
                let json: [String: String] = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                return json["request_id"]!
            })
    }
    
    func getJobStatus(customerId: String) -> Future<ZippyResult> {
        let url: URL = URL(string: baseUrl)!
            .appendingPathComponent("v1")
            .appendingPathComponent("result")
        let params: [String: String] = [
            "customer_uid": customerId,
            "secret_key": secret,
            "api_key": key,
        ]
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        var request: URLRequest = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        return session
            .request(request: request)
            .transformed(with: { (data) -> ZippyResult in
                print(String(data: data, encoding: .utf8) ?? "[unparsable]")
                return try self.decoder.decode([ZippyResult].self, from: data).first!
            })
    }
    
    func getCountries() -> Future<[Country]> {
        var request: URLRequest = URLRequest(url: URL(string: ZippyIdSDK.host + "sdk/countries")!)
        request.httpMethod = "GET"
        
        return session
            .request(request: request)
            .transformed(with: { (data) -> [Country] in
                print(String.init(data: data, encoding: .utf8) as Any)
                return try self.decoder.decode([Country].self, from: data)
            })
    }
    
    private func convertToFormParam(image: UIImage) -> String {
        return image.pngData()!.base64EncodedString().addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "+").inverted)!
    }
}
