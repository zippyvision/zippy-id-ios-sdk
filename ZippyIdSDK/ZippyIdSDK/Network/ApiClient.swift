//
//  ApiClient.swift
//  ZippyIdSDK
//
//  Created by Uģis Lazdiņš on 10/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

class ApiClient {
    let apiKey: String
    let baseUrl: String
    var session: URLSession = URLSession(configuration: .ephemeral)
    let decoder = JSONDecoder()
    
    init(apiKey: String, baseUrl: String) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
    func getToken() -> Future<String> {
        let url: URL = URL(string: baseUrl)!
            .appendingPathComponent("v1")
            .appendingPathComponent("request_tokens")
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Token token=" + apiKey, forHTTPHeaderField: "Authorization")
        
        return session
            .request(request: request)
            .transformed(with: { (data) -> String in
                let json: [String: String] = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                return json["token"]!
            })
    }
    
    func sendImages(token: String, document: Document, selfie: UIImage, documentFront: UIImage, documentBack: UIImage?, customerUid: String) -> Future<String> {
        print("Sending images with customerUid: \(customerUid)")
        
        let url: URL = URL(string: baseUrl)!
            .appendingPathComponent("v1")
            .appendingPathComponent("verifications")
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postBody: [String: String] = [
            "token": token,
            "document_country": "lv",
            "document_type": document.rawValue,
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
                return json["verification_id"]!
            })
    }
    
    func getJobStatus(customerId: String) -> Future<ZippyResult> {
        let url: URL = URL(string: baseUrl)!
            .appendingPathComponent("v1")
            .appendingPathComponent("verification")
        let params: [String: String] = ["customer_uid": customerId]
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        var request: URLRequest = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue("Token token=" + apiKey, forHTTPHeaderField: "Authorization")
        
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
