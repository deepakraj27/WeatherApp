//
//  ViewController.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 07/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import UIKit
import CoreLocation
import ObjectMapper
import MBProgressHUD

class WeatherVC: UIViewController {
    @IBOutlet weak var currentSelectedCityWeatherView: UIView!
    @IBOutlet weak var currentCityWeatherIcon: UIImageView!
    @IBOutlet weak var currentCityWeatherInDegrees: UILabel!
    @IBOutlet weak var currentCityWeatherStatusDescription: UILabel!
    @IBOutlet weak var currentLocationNameLabel: UILabel!
    @IBOutlet weak var showInCelsius: UIButton!
    @IBOutlet weak var showInFarrnheit: UIButton!
    @IBOutlet weak var dayAndTimeLabel: UILabel!
    @IBOutlet weak var notifyUserView: UIView!
    @IBOutlet weak var notifyImage: UIImageView!
    @IBOutlet weak var notifyHeading: UILabel!
    @IBOutlet weak var notifyDescription: UILabel!
    @IBOutlet weak var tryAgainButtonOutlet: UIButton!
    
    @IBOutlet weak var languageChooser: UIStackView!
    @IBOutlet weak var englishOutlet: UIButton!
    @IBOutlet weak var arabicOutlet: UIButton!
    
    var selectedLanguageisEnglish = true
    var showDegreesInCelsius: Bool = true
    var currentLocationName: String? = nil
    var weatherCurrentConditionData: GetCurrentConditionDone?
    var latLong: String? = nil

    fileprivate func selectedLanguage() {
        if selectedLanguageisEnglish{
            self.englishOutlet.setTitleColor(UIColor.blue, for: .normal)
            self.arabicOutlet.setTitleColor(UIColor.darkGray, for: .normal)
        }else{
            self.englishOutlet.setTitleColor(UIColor.darkGray, for: .normal)
            self.arabicOutlet.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetVcContent()
        selectedLanguage()
        showUIForCelsiusOrFarenheit()
        fetchLocationFromGPS()
    }

    fileprivate func resetVcContent(){
        self.languageChooser.isHidden = true
        self.currentSelectedCityWeatherView.isHidden = true
        self.notifyUserView.isHidden = true
    }
    
    fileprivate func showUIForCelsiusOrFarenheit() {
        // Do any additional setup after loading the view, typically from a nib.
        if showDegreesInCelsius{
            self.showInCelsius.setTitleColor(UIColor.blue, for: .normal)
            self.showInFarrnheit.setTitleColor(UIColor.darkGray, for: .normal)
        }else{
            self.showInCelsius.setTitleColor(UIColor.darkGray, for: .normal)
            self.showInFarrnheit.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    
    @IBAction func showInEnglish(_ sender: Any) {
        selectedLanguageisEnglish = true
        resetVcContent()
        selectedLanguage()
        showUIForCelsiusOrFarenheit()
        //just to speed up the process this has to be removed once all the locations are added
        if let latLong = latLong{
            showLoader()
            self.getLocationKey(latLong: latLong)
        }else{
            fetchLocationFromGPS()
        }
    }
    
    @IBAction func showInArabic(_ sender: Any) {
        selectedLanguageisEnglish = false
        resetVcContent()
        selectedLanguage()
        showUIForCelsiusOrFarenheit()
        //just to speed up the process this has to be removed once all the locations are added
        if let latLong = latLong{
            showLoader()
            self.getLocationKey(latLong: latLong)
        }else{
            fetchLocationFromGPS()
        }
    }
    
    @IBAction func tryAgainAction(_ sender: Any) {
        resetVcContent()
        fetchLocationFromGPS()
    }
    

    fileprivate func fetchLocationFromGPS() {
        LocationHandler.shared.settingLocationPermissions(vc: self)
        LocationHandler.shared.locationPickedBlock = {(latitude: CLLocationDegrees, longitude: CLLocationDegrees) in
            self.latLong = "\(latitude),\(longitude)"
            self.getLocationKey(latLong: "\(latitude),\(longitude)")
        }
        
        LocationHandler.shared.showLoader = {(showLoader) in
            if showLoader{
                self.showLoader()
            }else{
                self.hideLoader()
            }
        }
        
        LocationHandler.shared.locationDenied = {(notifyUser: String) in
            if notifyUser == "notifyUser"{
                self.notifyUserViewSetting("message_location_failure_heading".localized(), "message_location_failure".localized(), #imageLiteral(resourceName: "no_gps"))
            }
        }
        
        //If the location manager returns the error in fetching the location, then the page is reseted with the empty page. since it is not offline.
        LocationHandler.shared.errorInFetchingLocation = {(error: Error) in
            self.notifyUserViewSetting("message_location_failure_heading".localized(), "message_location_failure".localized(), #imageLiteral(resourceName: "no_gps"))
        }
    }
    
    
    @IBAction func showInCelsiusAction(_ sender: Any) {
        showDegreesInCelsius = true
        showWeather()
    }
    
    @IBAction func showInFarenheitAction(_ sender: Any) {
        showDegreesInCelsius = false
        showWeather()
    }
    
    fileprivate func showLoader(){
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    //check for the selected community id has location data, if location data is present then use top status bar loader and if no data is present for the community id then use the center loader
    fileprivate func hideLoader(){
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    fileprivate func notifyUserViewSetting(_ tilte: String, _ description: String, _ image: UIImage){
        self.hideLoader()
        self.notifyUserView.isHidden = false
        self.notifyHeading.text = tilte
        self.notifyDescription.text = description
        self.notifyImage.image = image
        tryAgainButtonOutlet.isHidden = true
        if tilte == "message_location_failure_heading".localized(){
            tryAgainButtonOutlet.isHidden = false
        }
    }
}

extension WeatherVC{
    //MARK:- Get Location Key API
    fileprivate func getLocationKey(latLong: String){
        var getLocationKeyInit = GetLocationKeyInit()
        if selectedLanguageisEnglish{
            getLocationKeyInit = GetLocationKeyInit(apikey: Constants.WEATHER_API_KEY, q: latLong,  language: Constants.EnglishLanguage)
        }else{
            getLocationKeyInit = GetLocationKeyInit(apikey: Constants.WEATHER_API_KEY, q: latLong,  language: Constants.ArabicLanguage)
        }
        WeatherHandler.getLocationKey(queryParams: getLocationKeyInit, withSuccess: { (response: GetLocationKeyDone) in
            if let locationKey = response.locationKey{
                self.currentLocationName = response.getLocationName()
                self.getCurrentConditions(locationKey: locationKey)
            }
        }, withFailure: {(err: Error) in
            self.hideLoader()
            self.notifyUserViewSetting("message_weather_data_not_loading_heading".localized(), "message_weather_data_not_loading_description".localized(), #imageLiteral(resourceName: "no_weather_data"))
        })
    }
    
    //MARK:- Get Current Conditions API
    //This current conditions of a location can only be fetched, if we have the location key from accuweather.
    fileprivate func getCurrentConditions(locationKey: String){
        var currentConditionInit = GetCurrentConditionInit()
        if selectedLanguageisEnglish{
            currentConditionInit = GetCurrentConditionInit(apikey: Constants.WEATHER_API_KEY, language: Constants.EnglishLanguage)
        }else{
            currentConditionInit = GetCurrentConditionInit(apikey: Constants.WEATHER_API_KEY, language: Constants.ArabicLanguage)
        }
        
        WeatherHandler.getCurrentConditions(locationKey: locationKey, queryParams: currentConditionInit, withSuccess: { (response: String) in
            self.hideLoader()
            
            DispatchQueue.global(qos: .background).async {
                if let getCurrentConditionDone = Mapper<GetCurrentConditionDone>().mapArray(JSONString: response){
                    if let currentConditionDatum = getCurrentConditionDone.first{
                        self.weatherCurrentConditionData = currentConditionDatum
                        DispatchQueue.main.async {
                            self.showWeather()
                        }
                    }
                }
            }
        }, withFailure: {(err: Error) in
            self.hideLoader()
            print("Show error screen and Failure in fetching the current condition")
        })
    }
    

    fileprivate func backgroundViewColorChange(_ temp: String) {
        let tempInNum = Double(temp) ?? 0
        if  tempInNum <= 20{
            self.view.backgroundColor = UIColor.paleBlue
        }else if tempInNum >= 21 && tempInNum <= 30{
            self.view.backgroundColor = UIColor.limeYellow
        }else if tempInNum >= 31 && tempInNum <= 50{
            self.view.backgroundColor = UIColor.swadOrange
        }else{
            self.view.backgroundColor = UIColor.red
        }
    }
    
    fileprivate func backgroundViewColorChangeForFarenheit(_ temp: String) {
        let tempInNum = Double(temp) ?? 0
        if  tempInNum <= Conversions.shared.celsiusToFahrenheit(tempInC: 20){
            self.view.backgroundColor = UIColor.paleBlue
        }else if tempInNum >= Conversions.shared.celsiusToFahrenheit(tempInC: 21) && tempInNum <= Conversions.shared.celsiusToFahrenheit(tempInC: 30){
            self.view.backgroundColor = UIColor.limeYellow
        }else if tempInNum >= Conversions.shared.celsiusToFahrenheit(tempInC: 31) && tempInNum <= Conversions.shared.celsiusToFahrenheit(tempInC: 50){
            self.view.backgroundColor = UIColor.swadOrange
        }else{
            self.view.backgroundColor = UIColor.red
        }
    }
    
    func getDateinRF339Format() -> String {
        let date = Date()
        let rfc339Formatter = DateFormatter()
        if selectedLanguageisEnglish{
            rfc339Formatter.locale = Locale(identifier: "en_US_POSIX")
        }else{
            rfc339Formatter.locale = Locale(identifier: "ar_DZ")
        }
        rfc339Formatter.dateFormat = "EEEE, hh:mm aa"
        rfc339Formatter.timeZone = TimeZone.current
        return rfc339Formatter.string(from: date)
    }
    
    func setAlignment(alignmnet: NSTextAlignment){
        self.dayAndTimeLabel.textAlignment = alignmnet
        self.currentLocationNameLabel.textAlignment = alignmnet
        self.currentCityWeatherStatusDescription.textAlignment = alignmnet
    }
    
    fileprivate func showWeather() {
        if let eachCellData = self.weatherCurrentConditionData{
            if selectedLanguageisEnglish {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                setAlignment(alignmnet: .left)
            }else{
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                setAlignment(alignmnet: .right)
            }
            
            self.languageChooser.isHidden = false
            self.notifyUserView.isHidden = true
            self.currentSelectedCityWeatherView.isHidden = false
            
            var temp : String = ""
            if let temperatureDetails = eachCellData.temperatureDetails{
                if showDegreesInCelsius{
                    temp = temperatureDetails.getTemperatureinCelsius() ?? ""
                    self.showInCelsius.setTitleColor(UIColor.blue, for: .normal)
                    self.showInFarrnheit.setTitleColor(UIColor.darkGray, for: .normal)
                    backgroundViewColorChange(temp)
                }else{
                    temp = temperatureDetails.getTemperatureinFahrenheit() ?? ""
                    self.showInCelsius.setTitleColor(UIColor.darkGray, for: .normal)
                    self.showInFarrnheit.setTitleColor(UIColor.blue, for: .normal)
                    backgroundViewColorChangeForFarenheit(temp)
                }
                hideLoader()
                self.currentCityWeatherInDegrees.text = temp
            }else{
                showLoader()
                self.currentCityWeatherInDegrees.text = ""
            }
            
            self.currentLocationNameLabel.text = currentLocationName ?? ""
            self.dayAndTimeLabel.text = getDateinRF339Format()
            if eachCellData.weatherIcon > 0{
                self.currentCityWeatherIcon.image = UIImage(named: "\(eachCellData.weatherIcon)")
            }else{
                self.currentCityWeatherIcon.image = nil
            }
            
            currentCityWeatherStatusDescription.text = eachCellData.weatherText ?? ""
            self.hideLoader()
        }
    }
}
