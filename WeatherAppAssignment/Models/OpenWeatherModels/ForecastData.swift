//
//  ForecastData.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 13/2/25.
//


import Foundation

// Request ----------------------------
//
//struct ForecastWeatherRequest: Encodable {
//    var lat: String!
//    var long: String!
//    var appid: String!
//
//    init(lat: String!, long: String!, appid: String!) {
//        self.lat = lat
//        self.long = long
//        self.appid = appid
//    }
//}

// Response ----------------------------

struct ForecastDataResponse: Decodable {
    var list: [CurrentWeatherResponse]?
}
