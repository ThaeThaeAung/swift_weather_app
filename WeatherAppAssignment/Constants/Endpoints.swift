//
//  NetworkingConstants.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 13/2/25.
//

import Foundation

struct ApiKeys {

    static var openCage = "7edb4ba1529a44a68f258a845e7fb2b5"
    static var openWeather = "9f3b6e1291c4da2e1edffacc2aec4006"

}

struct BaseURLs {

    static var openCageBaseUrl = "https://api.opencagedata.com/"
    static var openWeatherMapBaseUrl = "https://api.openweathermap.org/data/2.5/"

}

struct Endpoints {

    // open cage

    static var openCageGeoCode = "\(BaseURLs.openCageBaseUrl)geocode/v1/json"

    // open weather

    static var openWeatherCurrent = "\(BaseURLs.openWeatherMapBaseUrl)weather"
    static var openWeatherForecast = "\(BaseURLs.openWeatherMapBaseUrl)forecast"
    static func weatherIcon(iconName: String) -> String! {
        return "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    }

}
