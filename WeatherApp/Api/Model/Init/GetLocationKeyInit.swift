//
//  GetLocationKeyInit.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 08/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation
import ObjectMapper

class GetLocationKeyInit: Mappable{
    var apikey: String = ""
    var q: String = ""
    
    init(apikey: String, q: String) {
        self.apikey = apikey
        self.q = q
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        apikey <- map["apikey"]
        q <- map["q"]
    }
}
