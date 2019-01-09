//
//  LocationHandler.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 07/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationHandler: NSObject{
    static let shared = LocationHandler()
    fileprivate var currentVC: UIViewController?
    fileprivate var locationManager = CLLocationManager()
    
    //MARK: Internal Properties
    var locationPickedBlock: ((CLLocationDegrees, CLLocationDegrees) -> Void)?
    var errorInFetchingLocation: ((Error) -> Void)?
    var locationDenied: ((String) -> Void)?
    var showLoader:((Bool) -> Void)?
    
    //MARK:- Location Permission when using the app.
    func settingLocationPermissions(vc: UIViewController){
        currentVC = vc
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if status == .denied || status == .restricted {
            self.locationDenied?("notifyUser")
            let locationUnavailableAlert = UIAlertController (title: "message_access_location".localized() , message: nil, preferredStyle: .alert)

            let settingsAction = UIAlertAction(title:"label_settings".localized(), style: .destructive) { (_) -> Void in
                let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "action_cancel".localized(), style: .default, handler: nil)
            locationUnavailableAlert.addAction(cancelAction)
            locationUnavailableAlert.addAction(settingsAction)
            self.showLoader?(false)
            currentVC?.present(locationUnavailableAlert , animated: true, completion: nil)
        }
        
        if status == .authorizedWhenInUse{
            self.showLoader?(true)
        }
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func isLocationEnabled() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    func locationStatus() -> CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
}


extension LocationHandler: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.showLoader?(true)
        }else if status == .denied, status == .restricted{
            self.locationDenied?("notifyUser")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            if location.horizontalAccuracy > 0{
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                locationManager.stopUpdatingLocation()
                self.locationPickedBlock?(latitude, longitude)
                
                //                self.locationPickedBlock?("\(latitude), \(longitude)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showLoader?(false)
        self.errorInFetchingLocation?(error)
    }
}

