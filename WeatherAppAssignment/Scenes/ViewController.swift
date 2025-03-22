//
//  ViewController.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 10/2/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let request = GeocodingRequest(q: "Yangon", key: ApiKeys.openCage)

        NetworkManager.request(urlString: Endpoints.openCageGeoCode,
                                       method: .get,
                                       parameters: request,
                                       encoder: .urlEncodedForm,
                                       header: nil) { (data: CityDataResponse?, status: Int?, error: Error?) in

                    print("fetched")
                    print("status is \(status)")
                    print("error is \(error)")
                    if let data {
                        print(data.results?[0].name)
                    }
                }
    }


}

