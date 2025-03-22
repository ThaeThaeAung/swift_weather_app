//
//  WeatherDetailVC.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 4/3/25.
//

import Foundation
import UIKit
import Kingfisher

class WeatherDetailVC: UIViewController {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblWeatherName: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblClouds: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let vm = WeatherDetailVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        vm.fetchForecastData()
        vm.delegate = self
    }


    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func btnUnsubscribePressed(_ sender: Any) {
        self.vm.removeCityListItemFromLocalData()
        WeatherListVC.shared?.fetchCurrentWeatherForAllCities()
        self.dismiss(animated: true)
    }


    func setupView() {
        setupTableView()
        lblCityName.text = vm.dataStore.cityItemData.name
        lblWeatherName.text = vm.dataStore.currentWeatherData.description ?? ""
        lblTemperature.text = vm.dataStore.currentWeatherData.temp != nil ?
            "\(vm.dataStore.currentWeatherData.temp!)°C" : "-"
        lblHumidity.text = vm.dataStore.currentWeatherData.humidity != nil ?
            "\(vm.dataStore.currentWeatherData.humidity!)" : "-"
        lblWind.text = vm.dataStore.currentWeatherData.windSpeed != nil ?
            "\(vm.dataStore.currentWeatherData.windSpeed!)m/s" : "-"
        lblPressure.text = vm.dataStore.currentWeatherData.pressure != nil ?
            "\(vm.dataStore.currentWeatherData.pressure!)hPa" : "-"
        lblClouds.text = vm.dataStore.currentWeatherData.cloudValue != nil ?
            "\(vm.dataStore.currentWeatherData.cloudValue!)%" : "-"

            if let iconName = vm.dataStore.currentWeatherData.icon {
                let iconNameForDay = iconName.replacingOccurrences(of: "n", with: "d", options: .literal, range: nil)
                if let weatherIconUrl = URL(string: Endpoints.weatherIcon(iconName: iconNameForDay)) {
                    imgWeather.kf.setImage(with: weatherIconUrl)
                }
            }
        }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(UINib(nibName: "ForecastWeatherTableCell", bundle: nil), forCellReuseIdentifier: "ForecastWeatherTableCell")
    }
    func refreshTableView() {
        tableView.reloadData()
        tableViewHeight.constant = tableView.contentSize.height
    }


}
extension WeatherDetailVC: WeatherDetailVMProtocol {

    func ForecastWeatherSuccess() {
        refreshTableView()
    }

    func errorOccured(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alertController, animated: true)
       // hideLoadingIndicator()
    }
}

extension WeatherDetailVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        vm.dataStore.forecastWeatherList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = vm.dataStore.forecastWeatherList[section].formattedDate
        label.sizeToFit()
        let view = UIView()
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.dataStore.forecastWeatherList[section].weatherDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastWeatherTableCell", for: indexPath) as! ForecastWeatherTableCell
        cell.config(weatherData: vm.dataStore.forecastWeatherList[indexPath.section].weatherDataList[indexPath.row])
        return cell
    }
}


