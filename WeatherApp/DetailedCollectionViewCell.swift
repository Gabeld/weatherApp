//
//  DetailedCollectionViewCell.swift
//  WeatherApp
//
//  Created by Alex Dinu on 29/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit

class DetailedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var maxTemperatureLabel: UILabel!
    @IBOutlet var minTemperatureLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var mainWeatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
