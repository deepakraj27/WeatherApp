//
//  GetCurrentConditionsDone.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 07/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCurrentConditionDone: Mappable{
    var weatherText: String?
    var weatherIcon: Int = 0
    var temperatureDetails: TemperatureDetails?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        weatherText <- map["WeatherText"]
        weatherIcon <- map["WeatherIcon"]
        temperatureDetails <- map["Temperature"]
    }
}


class TemperatureDetails: Mappable{
    var celsius: Celsius?
    var farenheit: Farenheit?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        celsius <- map["Metric"]
        farenheit <- map["Imperial"]
    }
    
    func getTemperatureinCelsius() -> String?{
        if let celsius = self.celsius{
            return String(format:"%.0f", celsius.value)
        }else{
            if let farenheit = self.farenheit{
                return String(format:"%.0f", Conversions.shared.fahrenheitToCelsius(tempInF: farenheit.value))
            }
        }
        return nil
    }
    
    func getTemperatureinFahrenheit() -> String?{
        if let farenheit = self.farenheit{
            return String(format:"%.0f", farenheit.value)
        }else{
            if let celsius = self.celsius{
                return String(format:"%.0f", Conversions.shared.celsiusToFahrenheit(tempInC: celsius.value))
            }
        }
        return nil
    }
}

class Celsius: Mappable{
    var value: Double = 0
    var unit: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        value <- map["Value"]
        unit <- map["Unit"]
    }
}

class Farenheit: Mappable{
    var value: Double = 0
    var unit: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        value <- map["Value"]
        unit <- map["Unit"]
    }
}

