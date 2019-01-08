//
//  Conversions.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 07/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation

class Conversions{
    static let shared = Conversions()
    
    // Convert from F to C (Double)
    func fahrenheitToCelsius(tempInF:Double) ->Double {
        let celsius = (tempInF - 32.0) * (5.0/9.0)
        return celsius as Double
    }
    
    // Convert from C to F (Integer)
    func celsiusToFahrenheit(tempInC:Double) ->Double {
        let fahrenheit = (tempInC * 9.0/5.0) + 32.0
        return fahrenheit as Double
    }
}
