//
//  WeatherDetailVM.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 5/3/25.
//
import Foundation

struct ForecastWeatherListModel {
    var formattedDate: String!
    var weatherDataList: [CurrentWeatherResponse]!

    init(formattedDate: String!, weatherDataList: [CurrentWeatherResponse]!) {
        self.formattedDate = formattedDate
        self.weatherDataList = weatherDataList
    }
}

protocol WeatherDetailVMProtocol: AnyObject {
    func ForecastWeatherSuccess()
    func errorOccured(message: String)
}

class WeatherDetailDataStore {
    var cityListItemIndex = 0
    var cityItemData: CityListItemData!
    var currentWeatherData: CurrentWeatherResponse!
    var forecastWeatherList: [ForecastWeatherListModel] = []
}

class WeatherDetailVM {
    var dataStore = WeatherDetailDataStore()
    weak var delegate: WeatherDetailVMProtocol?

    func importNameAndCurrentWeatherData(cityItemData: CityListItemData!, currentWeatherData: CurrentWeatherResponse, cityListItemIndex: Int) {
        dataStore.cityItemData = cityItemData
        dataStore.currentWeatherData = currentWeatherData
        dataStore.cityListItemIndex = cityListItemIndex
    }

    func fetchForecastData() {
           let request = CurrentWeatherRequest(lat: dataStore.cityItemData.lat,
                                               lon: dataStore.cityItemData.lon,
                                               appid: ApiKeys.openWeather)

           NetworkManager.request(urlString: Endpoints.openWeatherForecast,
                                  method: .get,
                                  parameters: request,
                                  header: nil,
                                  completion: { (data: ForecastDataResponse?, status: Int?, error: Error?) in
               if let list = data?.list {
                   self.mapDataForForecastWeatherList(data: list)
                   self.delegate?.ForecastWeatherSuccess()
               } else if let error {
                   print(error)
                   self.delegate?.errorOccured(message: error.localizedDescription)
               }
           })
       }

       func mapDataForForecastWeatherList(data: [CurrentWeatherResponse]) {
           let formattedDateStringArray: [String] = data.map { $0.dateDaily ?? "" }.filter { $0 != "" }.unique()
           for date in formattedDateStringArray {
               let weatherListForDate = data.filter { $0.dateDaily == date }
               let forecastWeatherModel = ForecastWeatherListModel(formattedDate: date, weatherDataList: weatherListForDate)
               dataStore.forecastWeatherList.append(forecastWeatherModel)
           }
       }
    func removeCityListItemFromLocalData() {
        LocalDataManager.removeCityList(index: dataStore.cityListItemIndex)
        }

   }

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
