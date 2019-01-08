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
    var language: String = "en-us"
    //ar-sa for arabic
    init() {
        
    }
    
    init(apikey: String, language: String = "en-us") {
        self.apikey = apikey
        self.language = language
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        apikey <- map["apikey"]
        language <- map["language"]
    }
}
