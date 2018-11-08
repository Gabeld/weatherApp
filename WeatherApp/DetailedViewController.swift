//
//  DetailedViewController.swift
//  WeatherApp
//
//  Created by Alex Dinu on 29/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPageViewControllerDelegate, WeatherDataRendering {
    
    @IBOutlet var weekDayLabelOutletCollection: [UILabel]!
    @IBOutlet var forecastImageCollection: [UIImageView]!
    @IBOutlet var tempLabelOutletCollection: [UILabel]!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var detailedCollectionView: UICollectionView!
    @IBOutlet var pageController: UIPageControl!
    
    var itemIndex: IndexPath!
    var viewDidLayoutSubviewsForTheFirstTime = true
    var datesDict = [Int: [WeatherData]]()
    var weatherData = [Int:[AnyHashable: Any]]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        pageController.numberOfPages = CityManager.shared.cities.count
        
        getDataForCurrentCity()
        updateForecast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailedCollectionView.scrollToItem(at: itemIndex, at: .right, animated: true)
        detailedCollectionView.reloadData()
    }
    
    @IBAction func pageControllerDidChangeValue(_ sender: UIPageControl) {
        let indexPath = IndexPath(row: sender.currentPage, section: 0)
        let visibleCell = detailedCollectionView.visibleCells.first
        if let indexOfVisibleCell = detailedCollectionView.indexPath(for: visibleCell!) {
            pageController.currentPage = indexOfVisibleCell.row
            
            if indexPath.row < indexOfVisibleCell.row {
                detailedCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            } else if indexPath.row > indexOfVisibleCell.row {
                detailedCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        
        let newPage = Int(offSet + horizontalCenter) / Int(width)
        if pageController.currentPage != newPage {
            pageController.currentPage = newPage
            getDataForCurrentCity()
            updateForecast()
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
            
            dictionary[key] = ["minTemp": minTemp,
                               "maxTemp": maxTemp,
                               "avgTemp": maxTemp,
                               "condition": condition,
                               "conditionID": conditionID,
                               "day": dateFormatter]
            
            weatherData[key] = dictionary[key]
        }
    }
    
    func getDataForCurrentCity() {
        let index = pageController.currentPage
        let currentCity = CityManager.shared.cities[index]
        let currentData = currentCity.weatherData
        
        for day in 0..<6 {
            let date = Date(timeIntervalSinceNow: TimeInterval(86400 * day)) // 86400 == seconds in a day
            datesDict[day] = currentData.filter({ Calendar.current.compare($0.date, to: date, toGranularity: .day) == .orderedSame })
        }
        
        for key in datesDict.keys {
            filterWeatherData(dataArray: datesDict[key]!, key: key)
        }
    }
    
    func updateForecast() {
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
}
