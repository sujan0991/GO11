//
//  HTTPManager
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Alamofire
import Gloss


enum HTTPError: Error {
    case glossSerializationError
}

public func Request(
    _ method: HTTPMethod,
    _ urlString: String,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> DataRequest? {
        guard let fullUrl = URL(string: urlString, relativeTo: API_K.BaseURL) else {
            return nil
        }
        
        var header: HTTPHeaders = [:]
        
        if let currentToken = AppSessionManager.shared.authToken{
            header["Authorization"] = "Bearer \(currentToken)"
        }
       // header = ["Content-Type": "application/json"]
       // header.add(name: "Content-Type", value: "application/json")
        
        
        print(fullUrl, urlString, parameters)
        return AF.request( fullUrl, method: method, parameters: parameters , encoding: encoding, headers: header)
}

public func RequestForJson(
    _ method: HTTPMethod,
    _ urlString: String,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> DataRequest? {
        guard let fullUrl = URL(string: urlString, relativeTo: API_K.BaseURL) else {
            return nil
        }
        
        var header: HTTPHeaders = [:]
        
        if let currentToken = AppSessionManager.shared.authToken{
            header["Authorization"] = "Bearer \(currentToken)"
        }
        header.add(name: "Content-Type", value: "application/json")
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            
            
          //  AF.request("ghttps://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)

            return AF.request( fullUrl, method: method, parameters: parameters , encoding: JSONEncoding.default, headers: header).responseString { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
            
            }
        }
        else
        {
            return AF.request( fullUrl, method: method, parameters: parameters , encoding: encoding, headers: header)
        }
        
        
       
}
//public func MSRequest(
//    _ method: HTTPMethod,
//    _ urlString: String,
//      parameters: Parameters? = nil,
//      encoding: ParameterEncoding = URLEncoding.default,
//      headers: [String: String]? = nil)
//    -> DataRequest? {
//        guard let fullUrl = URL(string: urlString, relativeTo: API_K.BaseURL as URL) else {
//            return nil
//        }
//        return Request(method, fullUrl.absoluteString, parameters: parameters, encoding: encoding, headers: headers)
//
//      //  return request(fullUrl, method: method, parameters: parameters, encoding: encoding, headers: headers)
//}

//public func UploadRequest(
//    _ method: HTTPMethod,
//    _ urlString: String,
//      headers: [String: String]? = nil,
//      multipartFormData: @escaping (MultipartFormData) -> Void,
//      encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
//      encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
//{
//    guard let fullUrl = URL(string: urlString, relativeTo:API_K.BaseURL as URL) else {
//        return
//    }
//    /*multipartFormData: @escaping (MultipartFormData) -> Void,
//     usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
//     to url: URLConvertible,
//     method: HTTPMethod = .post,
//     headers: HTTPHeaders? = nil,
//     encodingCompletion:*/
//
//    print("fullUrl", fullUrl)
//
//    var header:[String:String] = [
//        "appKey":API_K.API_KEY]
//
//    if let currentToken = AppSessionManager.shared.authToken{
//        header["authToken"] = currentToken
//    }
//    /*
//    if let currentUser = AppSessionManager.shared.authToken{
//        header["authToken"] = currentUser
//    }
//    */
//    return upload(
//        multipartFormData: multipartFormData,
//        usingThreshold: encodingMemoryThreshold,
//        to: fullUrl,
//        method: method,
//        headers: header,
//        encodingCompletion: encodingCompletion
//    )
//}



