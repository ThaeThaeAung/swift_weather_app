//
//  WeatherListVM.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 22/2/25.
//

import Foundation

protocol WeatherListVMDelegate: AnyObject {
    func weatherListSuccess()
    func errorOccured(message: String)
}

class WeatherListDataStore {
    var currentWeatherDataList: [CurrentWeatherResponse] = []
    var fetchedWeatherCount = 0
}

class WeatherListVM {
    var dataStore = WeatherListDataStore()
    weak var delegate: WeatherListVMDelegate?
    var cities: [CityListItemData] { LocalDataManager.getCityList() }

    func fetchCurrentWeatherForAllCities() {
        dataStore.currentWeatherDataList.removeAll()
        dataStore.fetchedWeatherCount = 0

        if cities.count == 0 {
            delegate?.weatherListSuccess()
        }

        for i in 0..<cities.count {
            dataStore.currentWeatherDataList.append(CurrentWeatherResponse())
            fetchCurrentWeather(cityData: cities[i],index : i )
        }
    }

    func fetchCurrentWeather(cityData: CityListItemData,index : Int) {
        let request = CurrentWeatherRequest(lat: cityData.lat,
                                            lon: cityData.lon,
                                            appid: ApiKeys.openWeather)
        NetworkManager.request(urlString: Endpoints.openWeatherCurrent,
                                method: .get,
                                parameters: request,
                                 header: nil,
                                completion: { (data: CurrentWeatherResponse?, status: Int?, error: Error?) in
            if let data {
                //self.dataStore.currentWeatherDataList.append(data)
                self.dataStore.currentWeatherDataList[index] = data
            } else if let error {
                print(error)
                self.delegate?.errorOccured(message: error.localizedDescription)
            }
            self.dataStore.fetchedWeatherCount += 1
            if self.dataStore.fetchedWeatherCount == self.cities.count {
                self.delegate?.weatherListSuccess()
            }
        })
    }

    func removeCityListItemFromLocalData(index: Int) {
           dataStore.currentWeatherDataList.remove(at: index)
           LocalDataManager.removeCityList(index: index)
       }
}

