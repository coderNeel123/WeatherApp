//
//  Weather.swift
//  WeatherApp
//
//  Created by Neel Khattri on 8/7/16.
//  Copyright © 2016 SimpleStuff. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    private var _cityName: String!
    var cityName: String! {
        return _cityName
    }
    
    private var _sunset: String!
    var sunset: String! {
        return _sunset
    }
    
    private var _sunrise: String!
    var sunrise: String! {
        return _sunrise
    }
    
    private var _weatherDescription: String!
    var weatherDescription: String! {
        return _weatherDescription
    }
    
    private var _temperature: String!
    var temperatue: String! {
        return _temperature
    }
    
    private var _minTemperature: String!
    var minTemperature: String! {
        return _minTemperature
    }
    
    private var _maxTemperature: String!
    var maxTemperatue: String! {
        return _maxTemperature
    }
    
    
    private var _windSpeed: String!
    var windSpeed: String! {
        return _windSpeed
    }
    
    private var _humidity: String!
    var humidity: String! {
        return _humidity
    }
    
    private var _rainVolume: String!
    var rainVolume: String! {
        return _rainVolume
    }
    
    private var _pressure: String!
    var pressure: String! {
        return _pressure
    }
    
    init(cityName: String!) {
        _cityName = cityName
    }
        
    func weatherDetails (completed: DownloadComplete) {
        let finalUrl: String = "\(urlBase)\(_cityName)\(urlEnd)"
        let url = NSURL(string: finalUrl)
        finalUrl2 = url
        Alamofire.request(.GET, url!).responseJSON { (response) -> Void in
            let resultNeeded = response.result
            
            if let dictionary = resultNeeded.value  as? Dictionary<String, AnyObject> {
                if let description = dictionary["weather"] as? [Dictionary<String, AnyObject>] where description.count > 0 {
                    if let weatherDescriptionValue = description[0]["description"] {
                        self._weatherDescription = weatherDescriptionValue.capitalizedString as String
                    }
                }
                if let name = dictionary["name"] as? String {
                    self._cityName = name
                }
                if let temperatureRegular1 = dictionary["main"] as? Dictionary<String, Float> where temperatureRegular1.count > 0 {
                    if let temperatureRegular2 = temperatureRegular1["temp"] {
                        let stringConverted = String(temperatureRegular2)
                        self._temperature = self.convertKelvinToFarenhiet(stringConverted)
                    }
                    if let temperatureMin = temperatureRegular1["temp_min"] {
                        let stringConverted = String(temperatureMin)
                        self._minTemperature = self.convertKelvinToFarenhiet(stringConverted)
                    }
                    if let temperatureMax = temperatureRegular1["temp_max"] {
                        let stringConverted = String(temperatureMax)
                        self._maxTemperature = self.convertKelvinToFarenhiet(stringConverted)
                    }
                    if let humitidyData = temperatureRegular1["humidity"] {
                        self._humidity = String(humitidyData)
                    }
                    if let pressureData = temperatureRegular1["pressure"] {
                        self._pressure = String(Int(round(pressureData)))
                    }
                }
                if let sunTime = dictionary["sys"] as? Dictionary<String, AnyObject> where sunTime.count > 0 {
                    if let sunrise = sunTime["sunrise"] {
                        let stringConverted = String(sunrise)
                        self._sunrise = self.convertSunTime(stringConverted)
                    }
                    if let sunset = sunTime["sunset"] {
                        let stringConverted = String(sunset)
                        self._sunset = self.convertSunTime(stringConverted)
                    }
                }
                if let wind = dictionary["wind"] as? Dictionary<String, Float> where wind.count > 0 {
                    if let windSpeed = wind["speed"] {
                        self._windSpeed = String(windSpeed)
                    }
                }
                if let rain = dictionary["rain"] as? Dictionary<String, AnyObject> where rain.count > 0 {
                    if let rainVolumeAmount = rain["3h"] {
                        self._rainVolume = String(rainVolumeAmount)
                    }
                }
                else {
                    self._rainVolume = "0"
                }
                
                completed()
            }
        }
    }
    
    
    func convertKelvinToFarenhiet (value: String?) -> String {
        if let integerValue = Double(value!) {
             let farenhiet = (integerValue * 1.8 - 459.67)
                return String(format: "%.2f", farenhiet)
        }
        
        return "0.0"
        
    }
    
    func convertSunTime(timeToConvert: String) -> String {
        let date = NSDate(timeIntervalSince1970: Double(timeToConvert)!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(date)
    }
}