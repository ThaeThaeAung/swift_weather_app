//
//   CitySearchVC.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 21/2/25.
//

import Foundation
import UIKit

class CitySearchVC : UIViewController {

    @IBOutlet weak var txtSearch: UITextField!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let vm = CitySearchVM()
      var searchTask: Task<(), Error> = Task { return }

      override func viewDidLoad() {
          super.viewDidLoad()
          vm.delegate = self
          setupView()
      }

    func setupView() {
        txtSearch.becomeFirstResponder()
        loadingIndicator.isHidden = true
        setupTableView()
    }

      func setupTableView() {
          tableView.delegate = self
          tableView.dataSource = self
          tableView.rowHeight = 60
          tableView.register(UINib(nibName: "CitySearchTableCell", bundle: nil), forCellReuseIdentifier: "CitySearchTableCell")
      }

      // Text field actions
      @IBAction func txtEditingDidBegin(_ sender: Any) {
      }

      @IBAction func txtEditingChanged(_ sender: Any) {
          guard let text = txtSearch.text else { return }
          searchTask.cancel()
          if text.count >= 3 {
              startTask(text: text)
          }
      }

    func startTask(text: String) {
           let task = Task {
               try await Task.sleep(nanoseconds: 600_000_000)
               self.startFetching(text: text)
           }
           self.searchTask = task
       }

    func startFetching(text : String){
          vm.getCityList(query: text)
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }


       @IBAction  func txtEditingDidEnd(_ sender: Any) {
           print("editing end")
       }

       @IBAction func returnPressed(_ sender: Any) {
           view.endEditing(true)
       }

       // Button actions
       @IBAction func btnCancelPressed(_ sender: Any) {
           self.dismiss(animated: true)
       }

       @IBAction func btnClearPressed(_ sender: Any) {
           txtSearch.text = ""
       }
   }

   extension CitySearchVC: CitySearchVMDelegate {
       func citySearchSuccess() {
           hideLoadingIndicator()
           tableView.reloadData()
       }

       func errorOccured(message: String) {
           hideLoadingIndicator()
           let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
           present(alertController, animated: true)
       }

       func hideLoadingIndicator() {
           loadingIndicator.isHidden = true
           loadingIndicator.stopAnimating()
       }
   }
extension CitySearchVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.dataStore.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitySearchTableCell", for: indexPath) as! CitySearchTableCell
        cell.config(data: vm.dataStore.cities[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true)
        self.vm.addCityItemData(index: indexPath.row)
        WeatherListVC.shared?.fetchCurrentWeatherForAllCities()
    }
}

