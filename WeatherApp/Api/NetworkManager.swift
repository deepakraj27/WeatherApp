//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 08/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class NetworkManager: SessionManager {
    
    // MARK: - sharedInstance
    static let sharedInstance: NetworkManager = NetworkManager()
    static let manager: NetworkManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 20
        let manager = NetworkManager(configuration: configuration)
        return manager
    }()
    
    
    func requestUrl<T:Mappable>(url: URLRequestConvertible, withSuccess success:@escaping (_ response: T) -> (), withFailure failure:@escaping (_ error: Error) -> ()) {
        print("url in network manager:", url.urlRequest?.url?.absoluteString ?? "no url string")
        NetworkManager.manager.request(url).validate().responseObject { (response :DataResponse<T>) in
            guard response.result.isSuccess else{
                // if error presents, post to crashlytics and sentry
                failure(response.error!)
                return
            }
            success(response.result.value!)
        }
    }
    
    // MARK: - requestUrl
    func requestUrlJSON(url: URLRequestConvertible, withSuccess success:@escaping (_ response: String) -> (), withFailure failure:@escaping (_ error: Error) -> ()) {
        print("url in network manager:", url.urlRequest?.url?.absoluteString ?? "no url string")
    NetworkManager.manager.request(url).validate().responseString(encoding: String.Encoding.utf8) { response in
           
            guard response.result.isSuccess else{
                failure(response.error!)
                return
            }
            
        guard let json = response.result.value else {
                print("Malformed data received")
                failure(response.error!)
                return
            }
            
            success(json)
        }
    }
}
