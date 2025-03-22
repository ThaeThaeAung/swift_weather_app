//
//  WeatherListTableCell.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 14/2/25.
//

import Foundation
import UIKit
import Kingfisher

class WeatherListTableCell : UITableViewCell {

    @IBOutlet weak var lblWeatherName: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var bgView: UIView!
    

    func config(data: CurrentWeatherResponse, name: String) {
        lblCityName.text = name
        lblWeatherName.text = data.description ?? ""
        lblTemp.text = "\(data.temp ?? 0)°C"

        if let iconName = data.icon {
            let iconNameForDay = iconName.replacingOccurrences(of: "n", with: "d", options: .literal, range: nil)
            if let weatherIconUrl = URL(string: Endpoints.weatherIcon(iconName: iconNameForDay)) {
                imgWeather.kf.setImage(with: weatherIconUrl)
            }
        }
    }

    func config(data: CityListItemData) {
        lblCityName.text = data.name
    }

    
    func highlight() {
            UIView.animate(withDuration: 0.2, animations: {
                self.bgView.backgroundColor = .systemGray3
            })
        }

        func unHighlight() {
            UIView.animate(withDuration: 0.2, animations: {
                self.bgView.backgroundColor = .systemGray5
            })
        }

}
