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
    let value: Measurement<UnitTemperature>
    
    init(date: Date, value: Measurement<UnitTemperature>, condition: String, conditionID: Int) {
        self.date = date
        self.value = value
        self.condition = condition
        self.conditionID = conditionID
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(condition, forKey: "condition")
        aCoder.encode(conditionID, forKey: "conditionID")
        aCoder.encode(value, forKey: "value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as! Date
        condition = aDecoder.decodeObject(forKey: "condition") as! String
        conditionID = aDecoder.decodeInteger(forKey: "conditionID")
        value = aDecoder.decodeObject(forKey: "value") as! Measurement<UnitTemperature>
    }
    
    func printWeatherData() {
        print(self.date, self.value, self.condition)
    }
}
