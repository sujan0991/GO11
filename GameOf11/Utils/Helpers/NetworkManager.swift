//
//  NetworkManager.swift
//  Welltravel
//
//  Created by Amit Sen on 7/12/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import ObjectMapper

class NetworkManager {
    let loader = Loader.init()
    let asNet = ASNet.shared

//    let accessToken = Observable<String>("")
    var header: HTTPHeader = [:]

    init(withHost host: String, andBaseUrl url: String) {
        print("networkmanager init")
        asNet.initialize(withHost: host, andBaseURL: url)

//        self.header["content-type"] = "application/json"
        let result = App.sharedInstance.dataStoreManager.getClientId() + ":" + App.sharedInstance.dataStoreManager.getClientSecret()
        self.header["Authorization"] = "Basic " + result.base64Encoded()!
        self.header["Content-Type"] = "application/x-www-form-urlencoded"
        self.header["Cache-Control"] = "no-cache"
        self.header["content-type"] = "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"

//        _ = accessToken.observeNext(with: { (token) in
//            self.header[App.sharedInstance.texts.authorization] = App.sharedInstance.texts.bearer + " " + token
//        })
    }

    func changeHostAndBaseUrl(toHostUrl hostUrl: String, andBaseUrl baseUrl: String) {
        asNet.initialize(withHost: hostUrl, andBaseURL: baseUrl)
    }

    // swiftlint:disable function_parameter_count
    func apiCallForObjectResponse<T: Mappable>(endpointURL url: String,
                                               httpMethod method: HTTPMethod,
                                               parameters params: Parameters?,
                                               isMultiPart multipart: Bool,
                                               filesWhenMultipart files: ImageFileArray?,
                                               returningType type: T.Type,
                                               onComplete callback: @escaping(T, Any) -> Void) {
        loader.show()
        asNet.fetchAPIDataWithJsonObjectResponse(endpointURL: url,
                                                 httpMethod: method,
                                                 httpHeader: self.header,
                                                 parameters: params,
                                                 isMultiPart: multipart,
                                                 filesWhenMultipart: files,
                                                 returningType: type) { (result) in
            self.loader.hide()
            switch result {
            case .success(let object, let json):
                callback(object, json)
            case .error(let errorTitle, let errorText):
                App.sharedInstance.errorManager.errorMessage.next((errorTitle, errorText))
            }
        }
    }

    func apiCallForArrayResponse<T: Mappable>(endpointURL url: String,
                                              httpMethod method: HTTPMethod,
                                              parameters params: Parameters?,
                                              isMultiPart multipart: Bool,
                                              filesWhenMultipart files: ImageFileArray?,
                                              returningType type: T.Type,
                                              onComplete callback: @escaping([T], Any) -> Void) {
        loader.show()
        asNet.fetchAPIDataWithJsonArrayResponse(endpointURL: url,
                                                httpMethod: method,
                                                httpHeader: self.header,
                                                parameters: params,
                                                isMultiPart: multipart,
                                                filesWhenMultipart: files,
                                                returningType: type) { (result) in
            self.loader.hide()
            switch result {
            case .success(let objectArray, let json):
                callback(objectArray, json)
            case .error(let errorTitle, let errorText):
                App.sharedInstance.errorManager.errorMessage.next((errorTitle, errorText))
            }
        }
    }
    // swiftlint:enable function_parameter_count

    func loadImage(fromUrl url: String,
                   usingCache: Bool = true,
                   onSuccess successCallback: @escaping(UIImage?) -> Void) {

        asNet.loadImage(fromUrl: url,
                        usingCache: usingCache, onSuccess: { (image) in
            successCallback(image)
        }, onError: {
            App.sharedInstance.errorManager.errorMessage.next(("Error", "Error loading image!"))
        })
    }
}
