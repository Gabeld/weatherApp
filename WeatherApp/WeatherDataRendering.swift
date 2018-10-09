//
//  WeatherDataRendering.swift
//  WeatherApp
//
//  Created by Alex Dinu on 19/05/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherDataRendering {
    
    func temperatureColor(temperature: Int) -> UIColor
    func iconForWeatherCondition(conditionID: Int) -> UIImage
    
}

extension WeatherDataRendering {
    
    func temperatureColor(temperature: Int) -> UIColor {
        switch temperature {
        case _ where temperature <= 0:
            return UIColor(red: 0/255, green: 49/255, blue: 113/255, alpha: 1)
        case 0...9:
            return UIColor(red: 4/255, green: 79/255, blue: 103/255, alpha: 1)
        case 10...25:
            return UIColor(red: 210/255, green: 77/255, blue: 87/255, alpha: 1)
        case _ where temperature > 25:
            return UIColor(red: 157/255, green: 41/255, blue: 51/255, alpha: 1)
        default:
        // The switch was already exhaustive
            return UIColor.black
        }
    }
    func iconForWeatherCondition(conditionID: Int) -> UIImage {
        switch conditionID {
        case 200...299:
            return #imageLiteral(resourceName: "tstorms")
        case 300...399:
            return #imageLiteral(resourceName: "sleet")
        case 500...599:
            return #imageLiteral(resourceName: "rain")
        case 600...699:
            return #imageLiteral(resourceName: "snow")
        case 700...799:
            return #imageLiteral(resourceName: "hazy")
        case 800:
            return #imageLiteral(resourceName: "sunny_big")
        case 801...899:
            return #imageLiteral(resourceName: "nt_cloudy")
        case 900...910:
            return #imageLiteral(resourceName: "sunny_big")
        case 950...999:
            return #imageLiteral(resourceName: "sunny_big")
        default:
            return #imageLiteral(resourceName: "sunny_big")
        }
    }
}
