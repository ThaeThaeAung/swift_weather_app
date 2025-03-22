//
//  ForecastWeatherTableCell.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 5/3/25.
//

import Foundation
import UIKit

class ForecastWeatherTableCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeatherDesc: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!

    func config(weatherData: CurrentWeatherResponse) {
        lblWeatherDesc.text = weatherData.description?.capitalized ?? ""
        lblTemp.text = weatherData.temp != nil ? "\(weatherData.temp!)°C" : "-_-"
        lblDate.text = weatherData.dateHourly ?? ""

        if let iconName = weatherData.icon {
            let iconNameForDay = iconName.replacingOccurrences(of: "n", with: "d", options: .literal, range: nil)
            if let weatherIconUrl = URL(string: Endpoints.weatherIcon(iconName: iconNameForDay)) {
                imgWeather.kf.setImage(with: weatherIconUrl)
            }
        }
    }
}
