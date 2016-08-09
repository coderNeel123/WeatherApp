//
//  ViewController.swift
//  WeatherApp
//
//  Created by Neel Khattri on 8/7/16.
//  Copyright © 2016 SimpleStuff. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var rainVolume: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    
    let locationManager = CLLocationManager()
    var weather: Weather!
    var currentLocation: String!
    var location: Bool  = false
    var morningAndNight: Bool = false
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        searchBar.delegate = self
        refreshButton.hidden = true
        getLocation()
        backgroundTime()


        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func locationButtonClicked(sender: AnyObject) {
        getLocation()

    }
    
    @IBAction func refreshData(sender: AnyObject) {
        view.endEditing(true)
        
        if location == true {
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else {
        checkForCityNames()
        weather.weatherDetails { () -> () in
            self.updateUI()
            }
        }
    }
    
    func updateUI () {
        cityName.text = weather.cityName
        weatherDescription.text = weather.weatherDescription
        temperature.text = "\(weather.temperatue)°"
        minTemperature.text = "Min: \(weather.minTemperature)°"
        maxTemperature.text = "Max: \(weather.maxTemperatue)°"
        windSpeed.text = "Wind Speed: \(weather.windSpeed) MPH"
        pressure.text = "Pressure: \(weather.pressure) hPa"
        humidity.text = "Humidity: \(weather.humidity)%"
        rainVolume.text = "Rain Volume: \(weather.rainVolume)"
        sunset.text = "Sunset: \(weather.sunset)"
        sunrise.text = "Sunrise: \(weather.sunrise)"
        
        if let weatherDescriptionValue = weather.weatherDescription?.lowercaseString {
        whichImage(weatherDescriptionValue)
        }
        else {
            weatherImage.image = UIImage(named: "Other")
        }
    }
    
    
    
    func checkForCityNames () {
        if (String(searchBar.text) != nil) {
        cityName.text = cityNameValue
            if ((searchBar.text?.containsString(" ")) != nil) {
                let newValue = searchBar.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
                newValue?.lowercaseString
                weather = Weather(cityName: newValue)
                cityNameValue = searchBar.text

            }
        }
            
        else {
            cityNameValue = "Unknown"
        }
        
        
        
    }
    
    
    
    func checkCityName (location: String) {
            if ((location.containsString(" "))) {
                let newValue = location.stringByReplacingOccurrencesOfString(" ", withString: "")
                newValue.lowercaseString

                weather = Weather(cityName: newValue)
                cityNameValue = location
                
            }
            
        else {
                weather = Weather(cityName: location.lowercaseString)
                cityNameValue = location
                

        }
        
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
        checkForCityNames()
        weather.weatherDetails { () -> () in
            self.updateUI()
        }
        refreshButton.hidden = false
        location = false
    }
    
    
    
    
    
    func locationAuthorizationStatus () {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error)-> Void in
            if error == nil {
                let placemark = placemarks![0] 
                self.displayLocationInfo(placemark)
            }
            else {
                print(error.debugDescription)
            }
        })
    }
    
    
    
    func displayLocationInfo (placemark: CLPlacemark) {
        self.locationManager.stopUpdatingLocation()
        currentLocation = placemark.locality!
        checkCityName(currentLocation)
        view.endEditing(true)
        refreshButton.hidden = false
        weather.weatherDetails { () -> () in
            self.updateUI()
        }
    }


    func backgroundTime () {
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        
        if Int(hour) >= 0 && Int(hour) <= 6 {
            backgroundView.backgroundColor = UIColor.init(red: 40.0/255, green: 80.0/255, blue: 147.0/255, alpha: 1.0)
            morningAndNight = true
        }
        else if Int(hour) >= 7 && Int(hour) <= 1 {
            backgroundView.backgroundColor = UIColor.init(red: 75.0/255, green: 195.0/255, blue: 255.0/255, alpha: 1.0)
            morningAndNight = true

        }
        else if Int(hour) >= 12 && Int(hour) <= 15 {
            backgroundView.backgroundColor = UIColor.init(red: 236.0/255, green: 232.0/255, blue: 138.0/255, alpha: 1.0)
            morningAndNight = true
        }
        else if Int(hour) >= 16 && Int(hour) <= 19 {
            backgroundView.backgroundColor = UIColor.init(red: 225.0/255, green: 148.0/255, blue: 189.0/255, alpha: 1.0)
            morningAndNight = false
        }
        else if Int(hour) >= 20 && Int(hour) <= 23 {
            backgroundView.backgroundColor = UIColor.init(red: 70.0/255, green: 9.0/255, blue: 111.0/255, alpha: 1.0)
            morningAndNight = false
        }
        else {
            backgroundView.backgroundColor = UIColor.init(red: 40.0/255, green: 80.0/255, blue: 147.0/255, alpha: 1.0)
            morningAndNight = false
        }
    }
    
    func whichImage (weatherDescriptionVal: String!) {
        var weatherDescriptionComparer: String!
        if weatherDescriptionVal.containsString(" ") {
            let newString = weatherDescriptionVal.stringByReplacingOccurrencesOfString(" ", withString: "")
            weatherDescriptionComparer = newString
        }
        if weatherDescriptionComparer.containsString("clear")  {
            if morningAndNight == true {
                weatherImage.image = UIImage(named: "sunny")
            }
            else {
                weatherImage.image = UIImage(named: "moon")
            }
        }
        else if weatherDescriptionComparer.containsString("cloud") {
            if weatherDescriptionComparer.containsString("partly") {
                weatherImage.image = UIImage(named: "partly-cloudy")
            }
            else {
                weatherImage.image = UIImage(named: "cloudy")
            }
        }
        else if weatherDescriptionComparer.containsString("rain")  {
            weatherImage.image = UIImage(named: "rainy")
        }
        else if weatherDescriptionComparer.containsString("wind") {
            weatherImage.image = UIImage(named: "windy")
        }
        else if weatherDescriptionComparer.containsString("snow") {
            weatherImage.image = UIImage(named: "snowy")
        }
        else if weatherDescriptionComparer.containsString("storm") {
            weatherImage.image = UIImage(named: "stormy")
        }
        else {
            weatherImage.image = UIImage(named: "Other")
        }

    }
    
    func getLocation () {
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        location = true
    }
    
}

