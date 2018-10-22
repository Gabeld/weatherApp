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
    
    var cities: [City] = []
    
    let cityArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("cities.archive")
    }()
    
    func save(){
        print("Saving user data to \(cityArchiveURL)")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: cities, requiringSecureCoding: false)
            try data.write(to: cityArchiveURL)
            
        } catch {
            print("Error encoding \(error)")
        }
    }
    
    func loadCities() {
        do {
            let data = try Data(contentsOf: cityArchiveURL)
            guard let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [City] else {
                return
            }
            cities = array
        } catch {
            print("Can't encode data \(error)")
        }
    }
    
}
