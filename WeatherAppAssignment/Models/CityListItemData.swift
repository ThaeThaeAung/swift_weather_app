//
//  CityListItemData.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 22/2/25.
//

import Foundation

struct CityListItemData: Codable  {

    var name: String
    var lat: Double?
    var lon: Double?

    init(name: String, lat: Double, lon: Double) {
        self.name = name
        self.lat = lat
        self.lon = lon
    }
}
