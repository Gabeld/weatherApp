//
//  DetailedViewController.swift
//  WeatherApp
//
//  Created by Alex Dinu on 29/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WeatherDataRendering {
    
    @IBOutlet var weekDayLabelOutletCollection: [UILabel]!
    @IBOutlet var forecastImageCollection: [UIImageView]!
    @IBOutlet var tempLabelOutletCollection: [UILabel]!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var detailedCollectionView: UICollectionView!
    
    var itemIndex: IndexPath!
    var viewDidLayoutSubviewsForTheFirstTime = true
    var datesDict = [Int: [WeatherData]]()
    var weatherData = [Int:[AnyHashable: Any]]()
    
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CityManager.shared.cities.count
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard viewDidLayoutSubviewsForTheFirstTime == true else { return }
        viewDidLayoutSubviewsForTheFirstTime = false
        
        // Calling collectionViewContentSize forces the UICollectionViewLayout to actually render the layout
        let _ = detailedCollectionView.collectionViewLayout.collectionViewContentSize
        detailedCollectionView.scrollToItem(at: itemIndex, at: .right, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLayoutSubviewsForTheFirstTime = true
        detailedCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailedCollectionView.scrollToItem(at: itemIndex, at: .right, animated: true)
        detailedCollectionView.reloadData()
        
        for key in datesDict.keys {
            filterWeatherData(dataArray: datesDict[key]!, key: key)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = detailedCollectionView.bounds
        return CGSize(width: collectionViewSize.width, height: collectionViewSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailedCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailedCollectionViewCell", for: indexPath) as! DetailedCollectionViewCell
        let cities = CityManager.shared.cities
        
        if let mainWeather = cities[indexPath.row].weatherData.first {
            cell.temperature = Int(round(mainWeather.avgTemp.value))
            cell.minTemperatureLabel.text = String(Int(round(mainWeather.minTemp.value)))
            cell.maxTemperatureLabel.text = String(Int(round(mainWeather.maxTemp.value)))
            cell.mainConditionID = mainWeather.conditionID
        } else {
            cell.temperatureLabel.text = "-.-"
            cell.mainWeatherIcon.image = nil
            cell.maxTemperatureLabel.text = "-.-"
            cell.minTemperatureLabel.text = "-.-"
        }
        cell.cityNameLabel.text = cities[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let currentCity = CityManager.shared.cities[indexPath.row]
        let currentData = currentCity.weatherData
        
        for day in 0..<6 {
            let date = Date(timeIntervalSinceNow: TimeInterval(86400 * day)) // 86400 == seconds in a day
            datesDict[day] = currentData.filter({ Calendar.current.compare($0.date, to: date, toGranularity: .day) == .orderedSame })
        }
        
        for key in datesDict.keys {
            filterWeatherData(dataArray: datesDict[key]!, key: key)
        }
        
        for tag in 1...5 {
            if let value = weatherData[tag] {
                let temp = value["avgTemp"]
                let day = value["day"]
                let conditionID = value["conditionID"]
                weekDayLabelOutletCollection[tag - 1].text = day as? String
                tempLabelOutletCollection[tag - 1].text = "\(Int(round(temp as! Double))) °C"
                forecastImageCollection[tag - 1].image = iconForWeatherCondition(conditionID: conditionID as! Int)
                stackView.viewWithTag(tag)?.backgroundColor = temperatureColor(temperature: Int(round(temp as! Double)))
            }
        }
    }
    
    func filterWeatherData(dataArray: [WeatherData], key: Int) {
        var dictionary = [key: [:]]
        
        if let day = datesDict[key], !day.isEmpty {
            var minTemp = day[0].minTemp.value
            var maxTemp = day[0].maxTemp.value
            let condition = day.first?.condition ?? "Clear"
            let conditionID = day.first?.conditionID ?? 0
            let date = day.first?.date
            let dateFormatter: String = {
                let dtFormatter = DateFormatter()
                dtFormatter.setLocalizedDateFormatFromTemplate("EEE")
                let day = dtFormatter.string(from: date!)
                return day
            }()
            
            for item in day {
                minTemp = min(minTemp, item.minTemp.value)
                maxTemp = max(maxTemp, item.maxTemp.value)
            }
            
//            if day.count - 1 <= 2 {
//                // get first value
//                avgTemp = day[0].avgTemp.value
//            } else {
//                // get mid array value
//                avgTemp = day[(day.count - 1) / 2].avgTemp.value
//            }
            
            dictionary[key] = ["minTemp": minTemp,
                               "maxTemp": maxTemp,
                               "avgTemp": maxTemp,
                               "condition": condition,
                               "conditionID": conditionID,
                               "day": dateFormatter]
            
            weatherData[key] = dictionary[key]
        }
    }
}
