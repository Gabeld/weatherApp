//
//  CityManager.swift
//  WeatherApp
//
//  Created by Alex Dinu on 27/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import Foundation

class CityManager {
    
    static let shared = CityManager()
    
    var cities: [City] = [City(lat: 0, long: 0, name: "Arad", countryCode: "RO"), City(lat: 0, long: 0, name: "Timisoara", countryCode: "RO"), City(lat: 0, long: 0, name: "Moscow", countryCode: "RU"), City(lat: 0, long: 0, name: "Paris", countryCode: "FR")]
    
    let cityArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("cities.archive")
    }()
    
    func saveCities() {
        print("Saving user data to \(cityArchiveURL.path)")
        NSKeyedArchiver.archiveRootObject(cities, toFile: cityArchiveURL.path)
    }
    
}
