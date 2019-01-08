//
//  URLS.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 08/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation

struct Urls{
    static let WEATHER_BASE_URL = "https://weatherapi.noticeboard.tech/"
    struct WeatherRoutes {
        static let getLocationKeyURL = "locations/v1/cities/geoposition/search"
        static let getCurrentConditionURL = "currentconditions/v1/{locationKey}"
    }
}
