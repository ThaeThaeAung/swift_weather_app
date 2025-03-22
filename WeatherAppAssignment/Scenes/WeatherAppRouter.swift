//
//  WeatherAppRouter.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 22/2/25.
//

import Foundation
import UIKit

class WeatherAppRouter {

    static func presentCitySearchVC(parentVC: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CitySearchVC")
        parentVC.present(vc, animated: true)
    }

    static func presentWeatherDetailVC(parentVC: UIViewController, cityItemData: CityListItemData, currentWeatherData: CurrentWeatherResponse,cityListItemIndex: Int) {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherDetailVC") as?
                WeatherDetailVC {vc.vm.importNameAndCurrentWeatherData(
                    cityItemData: cityItemData,
                    currentWeatherData: currentWeatherData,
                    cityListItemIndex: cityListItemIndex
                )
               parentVC.navigationController?.pushViewController(vc, animated: true)
           }
       }
}
