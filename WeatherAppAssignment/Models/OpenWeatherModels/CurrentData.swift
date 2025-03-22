//
//  CurrentData.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 13/2/25.
//

import Foundation

// Request ----------------------------

struct CurrentWeatherRequest: Encodable {
    var lat: Double!
    var lon: Double!
    var appid: String!
    var units: String = "metric"

    init(lat: Double!, lon: Double!, appid: String!) {
        self.lat = lat
        self.lon = lon
        self.appid = appid
    }
}

// Response ----------------------------

struct CurrentWeatherResponse: Decodable {
    var dt: Double?
    var coord: WeatherCoordData?
    var weather: [WeatherData]?
    var main: WeatherMainData?
    var clouds: CloudData?
    var wind: WindData?
    var name: String?

    var dateHourly: String? {
        let date = Date(timeIntervalSince1970: self.dt ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
    }

    var dateDaily: String? {
        let date = Date(timeIntervalSince1970: self.dt ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: date)
    }
    
    var lat: Double? { return coord?.lat }
    var lon: Double? { return coord?.lon }
    var description: String? { return weather?.first?.description }
//    var name: String? { return weather?.first?.name }
    var icon: String? { return weather?.first?.icon }
    var temp: Double? { return main?.temp }
    var pressure: Double? { return main?.pressure }
    var humidity: Double? { return main?.humidity }
    var windSpeed: Double? { return wind?.speed }
    var cloudValue: Double? { return clouds?.cloudAll }

    private enum CodingKeys: String, CodingKey {
        case dt
        case coord
        case weather
        case main
        case clouds
        case wind
        case name
    }
}

struct WeatherCoordData: Decodable {
    var lon: Double?
    var lat: Double?
}

struct WeatherData: Encodable, Decodable {
    var name: String?
    var description: String?
    var icon: String?

    private enum CodingKeys: String, CodingKey {
        case name = "main"
        case description
        case icon
    }
}

struct WeatherMainData: Decodable {
    var temp: Double?
    var pressure: Double?
    var humidity: Double?
}

struct CloudData: Decodable {
    var cloudAll: Double?

    private enum CodingKeys: String, CodingKey {
        case cloudAll = "all"
    }
}

struct WindData: Decodable {
    var speed: Double?
}
