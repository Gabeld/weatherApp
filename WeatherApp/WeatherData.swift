//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Alex Dinu on 17/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import Foundation

class WeatherData: NSObject, NSCoding {
    
    let date: Date
    let condition: String
    let conditionID: Int 
    let avgTemp: Measurement<UnitTemperature>
    let minTemp: Measurement<UnitTemperature>
    let maxTemp: Measurement<UnitTemperature>

    
    
    init(date: Date, avgTemp: Measurement<UnitTemperature>, minTemp: Measurement<UnitTemperature>, maxTemp: Measurement<UnitTemperature>, condition: String, conditionID: Int) {
        self.date = date
        self.avgTemp = avgTemp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.condition = condition
        self.conditionID = conditionID
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(condition, forKey: "condition")
        aCoder.encode(conditionID, forKey: "conditionID")
        aCoder.encode(avgTemp, forKey: "avgTemp")
        aCoder.encode(minTemp, forKey: "minTemp")
        aCoder.encode(maxTemp, forKey: "maxTemp")
    }
    
    required init?(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as! Date
        condition = aDecoder.decodeObject(forKey: "condition") as! String
        conditionID = aDecoder.decodeInteger(forKey: "conditionID")
        avgTemp = aDecoder.decodeObject(forKey: "avgTemp") as! Measurement<UnitTemperature>
        minTemp = aDecoder.decodeObject(forKey: "minTemp") as! Measurement<UnitTemperature>
        maxTemp = aDecoder.decodeObject(forKey: "maxTemp") as! Measurement<UnitTemperature>
    }
    
    func printWeatherData() {
        print(self.date, self.avgTemp, self.condition)
    }
}
