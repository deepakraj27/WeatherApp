//
//  GetCurrentConditionInit.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 08/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCurrentConditionInit: Mappable{
    var apikey: String = ""
    
    init(apikey: String) {
        self.apikey = apikey
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        apikey <- map["apikey"]
    }
}
