//
//  Constants.swift
//  WeatherApp
//
//  Created by Neel Khattri on 8/7/16.
//  Copyright © 2016 SimpleStuff. All rights reserved.
//

import Foundation

let urlBase = "http://api.openweathermap.org/data/2.5/weather?q="
let urlEnd = "&appid=137603e0c6ae7dc4de3bd30cf19713ff"
var cityNameValue: String!
var finalUrl2: NSURL!
typealias DownloadComplete = () -> ()