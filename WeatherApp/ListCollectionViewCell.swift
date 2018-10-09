//
//  ListCollectionViewCell.swift
//  WeatherApp
//
//  Created by Alex Dinu on 23/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell, WeatherDataRendering {
    
    static let reuseIdentifier = "ListCollectionViewCell"
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cellContentView: UIView!
    
    var temperature: Int = 0 {
        didSet {
            temperatureLabel.text = "\(String(temperature)) °C"
            backgroundColor = temperatureColor(temperature: temperature)
            
        }
    }
    
    var mainConditionID: Int = 0 {
        didSet {
            imageView.image = iconForWeatherCondition(conditionID: mainConditionID)
        }
    }
    
    
    var longPressAction: ((ListCollectionViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized(_:)))
        cellContentView.addGestureRecognizer(longGestureRecognizer)
        
        layer.cornerRadius = 7
        layer.masksToBounds = true
    }
    
    @objc func longPressRecognized(_ gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            if let longPressAction = longPressAction {
                longPressAction(self)
            }
        }
    }

}
