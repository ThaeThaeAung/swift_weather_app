//
//  CitySearchTableCell.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 21/2/25.
//

import Foundation
import UIKit

class CitySearchTableCell : UITableViewCell {

    
    @IBOutlet weak var lblCityName: UILabel!

    func config(data : CityData){

        lblCityName.text = data.name ?? "no name"
    }
}
