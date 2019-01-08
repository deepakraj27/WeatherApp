//
//  GetLocationKeyDone.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 08/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation
import ObjectMapper

class GetLocationKeyDone: Mappable{
    var englishName: String?
    var locationKey: String?
    var parentCity: ParentCity?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        englishName <- map["EnglishName"]
        locationKey <- map["Key"]
        parentCity <- map["ParentCity"]
    }
    
}


class ParentCity: Mappable{
    var englishName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        englishName <- map["EnglishName"]
    }
}
