//
//  ListCollectionViewCell.swift
//  WeatherApp
//
//  Created by Alex Dinu on 23/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ListCollectionViewCell"
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    
    var temperature: Int = 0 {
        didSet {
            temperatureLabel.text = "\(String(temperature)) °C"
            
            switch temperature {
            case _ where temperature <= 0:
                backgroundColor = UIColor(red: 0/255, green: 49/255, blue: 113/255, alpha: 1)
            case 0...9:
                backgroundColor = UIColor(red: 4/255, green: 79/255, blue: 103/255, alpha: 1)
            case 10...25:
                backgroundColor = UIColor(red: 210/255, green: 77/255, blue: 87/255, alpha: 1)
            case _ where temperature > 25:
                backgroundColor = UIColor(red: 157/255, green: 41/255, blue: 51/255, alpha: 1)
            default:
                break
            }
        }
    }
    
    var mainConditionID: Int = 0 {
        didSet {
        
            switch mainConditionID {
            case 200...299:
                imageView.image = #imageLiteral(resourceName: "tstorms")
            case 300...399:
                imageView.image = #imageLiteral(resourceName: "sleet")
            case 500...599:
                imageView.image = #imageLiteral(resourceName: "rain")
            case 600...699:
                imageView.image = #imageLiteral(resourceName: "snow")
            case 700...799:
                imageView.image = #imageLiteral(resourceName: "hazy")
            case 800:
                imageView.image = #imageLiteral(resourceName: "sunny_big")
            case 801...899:
                imageView.image = #imageLiteral(resourceName: "nt_cloudy")
            case 900...910:
                imageView.image = #imageLiteral(resourceName: "sunny_big")
            case 950...999:
                imageView.image = #imageLiteral(resourceName: "sunny_big")
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 7
        layer.masksToBounds = true
    }
    
}
