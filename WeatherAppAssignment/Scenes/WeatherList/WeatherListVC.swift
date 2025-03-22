//
//  WeatherListVC.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 14/2/25.
//

import Foundation
import UIKit

class WeatherListVC: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var lblPleaseAddCity: UILabel!

    static var shared: WeatherListVC?

    let vm = WeatherListVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherListVC.shared = self
        vm.delegate = self
        fetchCurrentWeatherForAllCities()
        setupView()
    }

    func setupView() {
        loadingIndicator.isHidden = true
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WeatherListTableCell", bundle: nil), forCellReuseIdentifier: "WeatherListTableCell")
    }

    func fetchCurrentWeatherForAllCities() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        vm.fetchCurrentWeatherForAllCities()
    }

    func refreshView() {
        print("refresh view")
        tableView.reloadData()
    }

      func showOrHideLblPleaseAddCity() {
          lblPleaseAddCity.isHidden = !vm.dataStore.currentWeatherDataList.isEmpty
      }

    func goToWeatherDetail(index: Int) {
        let cityItemData = LocalDataManager.getCityList()[index]
        let currentWeatherData = vm.dataStore.currentWeatherDataList[index]
        WeatherAppRouter
            .presentWeatherDetailVC(
                parentVC: self,
                cityItemData: cityItemData,
                currentWeatherData: currentWeatherData,
                cityListItemIndex: index
            )
    }

    func removeCityDataAndRefreshTableView(indexPath: IndexPath) {

          vm.removeCityListItemFromLocalData(index: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .automatic)
          tableView.endUpdates()
           tableView.reloadData()
          showOrHideLblPleaseAddCity()
      }



    @IBAction func btnAddPressed(_ sender: Any) {
        WeatherAppRouter.presentCitySearchVC(parentVC: self)
    }
}

extension WeatherListVC: WeatherListVMDelegate {
    func weatherListSuccess() {
        print("weather success")
        refreshView()
        hideLoadingIndicator()
        showOrHideLblPleaseAddCity()
    }

    func errorOccured(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alertController, animated: true)
        hideLoadingIndicator()
        showOrHideLblPleaseAddCity()
    }

    func hideLoadingIndicator() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
}

extension WeatherListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // LocalDataManager.getCityList().count
        vm.dataStore.currentWeatherDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableCell", for: indexPath) as! WeatherListTableCell
        cell.config(data: vm.dataStore.currentWeatherDataList[indexPath.row], name: LocalDataManager.getCityList()[indexPath.row].name)
        // cell.config(data: LocalDataManager.getCityList()[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goToWeatherDetail(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WeatherListTableCell
        cell.highlight()
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WeatherListTableCell
        cell.unHighlight()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Unsubscribe", handler: { action, swipeButtonView, completion in

            self.removeCityDataAndRefreshTableView(indexPath: indexPath)
            completion(true)
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
}
