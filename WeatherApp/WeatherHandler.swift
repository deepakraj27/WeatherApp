//
//  WeatherHandler.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 07/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherHandler{
    class func getLocationKey(queryParams: GetLocationKeyInit, withSuccess success: @escaping(_ res: GetLocationKeyDone) -> (), withFailure failure:@escaping (_ err:Error) -> ()){
        NetworkManager.manager.requestUrl(url: WeatherRouter.getLocationKey(queryParams: queryParams.toJSON()), withSuccess: { (response: GetLocationKeyDone) in
            success(response)
        }, withFailure: {(err: Error) in
            print("Failure in fetching locationKey", err.localizedDescription)
            failure(err)
        })
    }
    
    class func getCurrentConditions(locationKey: String, queryParams: GetCurrentConditionInit, withSuccess success: @escaping(_ res: String) -> (), withFailure failure:@escaping (_ err:Error) -> ()){
        NetworkManager.manager.requestUrlJSON(url: WeatherRouter.getCurrentCondition(locationKey: locationKey, queryParams: queryParams.toJSON()), withSuccess: { (jsonString: String) in
            success(jsonString)
        }, withFailure: {(err: Error) in
            print("Failure in fetching current condition", err.localizedDescription)
            failure(err)
        })
    }
}
