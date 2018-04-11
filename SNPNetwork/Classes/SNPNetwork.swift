//
//  SNPAlamofireObjectMapper.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/4/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

import Alamofire

public typealias Parameters = Alamofire.Parameters

public class SNPNetwork {
    static var localizedHeaderValue: String = {
        let currentLanguage = UserDefaults.standard.object(forKey: UserDefaultsKeys.currentLanguage) as! String
        
        if currentLanguage.hasPrefix("fa") {
            return "fa-IR"
        } else if currentLanguage.hasPrefix("en") {
            return "en-GB"
        } else if currentLanguage.hasPrefix("fr") {
            return "fr-FR"
        } else {
            // fallback to Farsi
            return "fa-IR"
        }
    }()
    
    public class func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                   method: HTTPMethod = .get,
                                                   parameters: Parameters? = nil,
                                                   encoding: ParameterEncoding = URLEncoding.default,
                                                   headers: HTTPHeaders? = nil,
                                                   responseKey: String? = nil,
                                                   completion: @escaping (T?, E?) -> Void) {
        
        var localizedHeaders: HTTPHeaders
        if headers == nil {
            localizedHeaders = ["locale": localizedHeaderValue]
        } else {
            localizedHeaders = headers!
            localizedHeaders["locale"] = localizedHeaderValue
        }
        
        let genericSNPError = SNPError.generic()
        let genericError = E(domain: genericSNPError.domain,
                             code: genericSNPError.code,
                             message: genericSNPError.message)
        
        let alamofireRequest = Alamofire.request(url,
                                                 method: method,
                                                 parameters: parameters,
                                                 encoding: encoding,
                                                 headers: headers)
        
        alamofireRequest.responseData { response in
            if let statusCode = response.response?.statusCode, let jsonData = response.value {
                if statusCode.isAValidHTTPCode {
                    do {
                        let resultDic = try JSONDecoder().decode(SNPDecodable.self,
                                                                 from: jsonData).value as! [String: Any]
                        if responseKey == nil {
                            let result = resultDic as? T
                            completion(result, nil)
                        } else {
                            let result: T = resultDic.toModel(key: responseKey)
                            completion(result, nil)
                        }
                    } catch {
                        // error parsing response to T
                        completion(nil, genericError)
                    }
                } else {
                    do {
                        let error = try JSONDecoder().decode(E.self, from: jsonData)
                        completion(nil, error)
                    } catch {
                        // error parsing response to E
                        completion(nil, genericError)
                    }
                }
            } else {
                // unknown network error
                completion(nil, genericError)
            }
        }
    }
    
    public class func download(_ url: String,
                        progress: ((_ progress: Double) -> Void)?,
                        completion: @escaping (_ status: String?) -> Void) {
        Utilities.clearTempDirectory()
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download(url, to: destination)
            .downloadProgress( closure: { prog in
                progress!(prog.fractionCompleted)
            })
            .response(completionHandler: { defaultDownloadResponse in
                if let error = defaultDownloadResponse.error {
                    completion(error.localizedDescription)
                } else {
                    completion("Downloaded file successfully to \(destination)")
                }
            })
    }
}
