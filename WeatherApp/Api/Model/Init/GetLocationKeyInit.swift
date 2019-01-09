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
    var language: String = "en-us"
    
    init() {
        
    }
    
    init(apikey: String, q: String, language: String = "en-us") {
        self.apikey = apikey
        self.q = q
        self.language = language
    }
   
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        apikey <- map["apikey"]
        q <- map["q"]
        language <- map["language"]
    }
}
