//
//  City.swift
//  WeatherApp
//
//  Created by Alex Dinu on 17/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import Foundation

class City: NSObject, NSCoding {
   
    var lat: Double
    var long: Double
    var name: String
    let countryCode: String
    var weatherData = [WeatherData]()
    
    init(lat: Double, long: Double, name: String, countryCode: String) {
        self.lat = lat
        self.long = long
        self.name = name
        self.countryCode = countryCode
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(long, forKey: "long")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(countryCode, forKey: "countryCode")
        aCoder.encode(weatherData, forKey: "weatherData")
    }
    
    required init?(coder aDecoder: NSCoder) {
        lat = aDecoder.decodeDouble(forKey: "lat")
        long = aDecoder.decodeDouble(forKey: "long")
        name = aDecoder.decodeObject(forKey: "name") as! String
        countryCode = aDecoder.decodeObject(forKey: "countryCode") as! String
        weatherData = aDecoder.decodeObject(forKey: "weatherData") as! [WeatherData]
    }
    
    func printself() {
        print(lat, long, name, countryCode)
    }
}
