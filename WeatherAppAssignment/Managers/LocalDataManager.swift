//
//  LocalDataManager.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 22/2/25.
//

import Foundation

class LocalDataManager {

    static func addCityItemData(data: CityListItemData) {
        var cityItemList = getCityList()
        cityItemList.append(data)
        saveCityList(cityItemList: cityItemList)
    }

    static func getCityList() -> [CityListItemData] {
        return UserDefaults.standard.getCustomObject(forKey: UserDefaultKeys.cityListKey, castTo: [CityListItemData].self) ?? []
    }

    static func saveCityList(cityItemList: [CityListItemData]) {
        UserDefaults.standard.setCustomObject(cityItemList, forKey: UserDefaultKeys.cityListKey)
    }

    static func removeCityList(index: Int!) {
           var cityList = getCityList()
           cityList.remove(at: index)
           saveCityList(cityItemList: cityList)
       }
}

extension UserDefaults {

    func setCustomObject<Object>(_ object: Object, forKey: String) where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            return
        }
    }


    func getCustomObject<Object>(forKey: String, castTo type: Object.Type) -> Object? where Object: Decodable {
        guard let data = data(forKey: forKey) else {
            print("No data for key")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            return nil
        }
    }
}
