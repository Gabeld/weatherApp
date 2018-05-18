//
//  WeatherHandler.swift
//  WeatherApp
//
//  Created by Alex Dinu on 17/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import Foundation

class WeatherHandler {
    let baseURLString = "https://api.openweathermap.org/data/2.5"
    let apiKey = "3a51b59060b2d0bbf6a50e2897788d66"
    
    func weatherForCity(city: City, completion: @escaping ((_ success: Bool) -> Void)) {
        var components = URLComponents(string: "\(baseURLString)/forecast")
        var queryItems = [URLQueryItem]()
        
        let parameters = [
                        "APPID": apiKey,
                        "q": "\(city.name),\(city.countryCode)",
                        "units": "metric"]
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        components?.queryItems = queryItems
        
        guard let cityURL = components?.url else {
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        print(cityURL)
        var request = URLRequest(url: cityURL)
        request.addValue("Accept", forHTTPHeaderField: "application/json")
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    guard
                        let jsonDictionary = jsonObject as? [String: AnyObject],
                        let jsonCity = jsonDictionary["city"] as? [String: AnyObject],
                        let coords = jsonCity["coord"] as? [String: Double],
                        let weatherList = jsonDictionary["list"] as? [[String: AnyObject]] else {
                            DispatchQueue.main.async {
                                completion(false)
                            }
                            return
                    }
                    city.lat = coords["lat"] ?? 0
                    city.long = coords["lon"] ?? 0
                    print(weatherList, city.lat, city.long)
                    var weatherDataList = [WeatherData]()
                    
                    for weatherItem in weatherList {
                        let weatherArrray = weatherItem["weather"] as? [[String: AnyObject]]
                        
                        let weatherDictionary = weatherArrray?.first
                        let weatherCondition = weatherDictionary!["main"] as!  String
                        let conditionID = weatherDictionary!["id"] as! Int
                        let date = weatherItem["dt"]
                        let weatherDate = Date(timeIntervalSince1970: date!.doubleValue)
                        let tempDictionary = weatherItem["main"] as? [String: Double]
                        let tempValue = tempDictionary!["temp"] ?? 0
                        let value = Measurement(value: tempValue, unit: UnitTemperature.celsius)
                        let weatherData = WeatherData(date: weatherDate, value: value, condition: weatherCondition, conditionID: conditionID)
                        weatherDataList.append(weatherData)
                    }
                    
                    city.weatherData = weatherDataList
                    
                    DispatchQueue.main.async {
                        completion(true)
                    }
                    print(city)
                } catch let error {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    print("Error reading jsonData \(error)")
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        task.resume()
    }
}
