//
//  WeatherRouter.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 08/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum WeatherRouter: URLRequestConvertible{
    case getLocationKey(queryParams: Parameters)
    case getCurrentCondition(locationKey: String, queryParams: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .getLocationKey:
            return .get
        case .getCurrentCondition:
            return .get
        }
    }
    
    var path : String{
        switch self {
        case .getLocationKey:
            return Urls.WeatherRoutes.getLocationKeyURL
        case .getCurrentCondition(let locationKey, _):
            let getCurrentConditionPath = Urls.WeatherRoutes.getCurrentConditionURL.replacingOccurrences(of: "{locationKey}", with: locationKey, options: .literal, range: nil)
            return getCurrentConditionPath
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let HEADER : HTTPHeaders = [
            "X-NB-Request-ID": UUID().uuidString,
            "X-NB-User-Agent": "ios/ 1.0",
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json",
            "Cache-Control": "no-cache",
            "User-Agent": "tech.noticeboard.iOS"
        ]
        
        let url = try Urls.WEATHER_BASE_URL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = HEADER
        urlRequest.timeoutInterval = 60
        
        switch self {
        case .getLocationKey(let queryParams):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParams)
        case .getCurrentCondition(_ , let queryParams):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParams)
        }
        return urlRequest
    }
    
}
