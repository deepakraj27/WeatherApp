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
    var administrativeArea: AdministrativeArea?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        englishName <- map["EnglishName"]
        locationKey <- map["Key"]
        parentCity <- map["ParentCity"]
        administrativeArea <- map["AdministrativeArea"]
    }
    
    
    func getLocationName() -> String{
        var locationName: String = ""
        if let state = self.administrativeArea, let localizedStateName = state.LocalizedName, let city = parentCity, let cityLocalizedName = city.LocalizedName{
            locationName = "\(cityLocalizedName), \(localizedStateName)"
        }else{
            if let state = self.administrativeArea, let localizedStateName = state.LocalizedName{
                locationName = localizedStateName
            }else{
                if let city = parentCity, let cityLocalizedName = city.LocalizedName{
                    locationName = cityLocalizedName
                }
            }
        }
        return locationName
    }
}

class AdministrativeArea: Mappable{
    var englishName: String?
    var LocalizedName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        englishName <- map["EnglishName"]
        LocalizedName <- map["LocalizedName"]
    }
}

class ParentCity: Mappable{
    var englishName: String?
    var LocalizedName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        englishName <- map["EnglishName"]
        LocalizedName <- map["LocalizedName"]
    }
}
