//
//  CitySearchVM.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 22/2/25.
//

import Foundation

protocol CitySearchVMDelegate: AnyObject {
    func errorOccured (message: String)
    func citySearchSuccess()
}

class CitySearchDataStore {
    var cities: [CityData] = []
}

class CitySearchVM {
    var dataStore = CitySearchDataStore()
    weak var delegate: CitySearchVMDelegate?

    func getCityList(query: String) {
        let request = GeocodingRequest(q: query, key: ApiKeys.openCage)
        NetworkManager.request(urlString: Endpoints.openCageGeoCode,
                                method: .get,
                                parameters: request,
                               header: nil) {
            (data: CityDataResponse?, status: Int?, error: Error?) in
            if let data {
                self.modifyCityData(data: data)
                self.delegate?.citySearchSuccess()
            } else if let error {
                print(error)
                self.delegate?.errorOccured(message: error.localizedDescription)
            }
        }
    }

    func modifyCityData(data: CityDataResponse) {
        self.dataStore.cities = (data.results ?? []).filter{ $0.name != nil }
    }

    func addCityItemData(index: Int) {
           let name = dataStore.cities[index].name ?? ""
           let lat = dataStore.cities[index].lat ?? 0.0
           let lon = dataStore.cities[index].lon ?? 0.0
           let newCityData = CityListItemData(name: name, lat: lat, lon: lon)
           LocalDataManager.addCityItemData(data: newCityData)
       }
}
