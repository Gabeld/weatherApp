//
//  ListViewController.swift
//  WeatherApp
//
//  Created by Alex Dinu on 22/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var collectionView: UICollectionView!
    let weatherHandler = WeatherHandler()
    var cities: [City] = [City(lat: 0, long: 0, name: "London", countryCode: "UK"), City(lat: 0, long: 0, name: "Arad", countryCode: "RO"), City(lat: 0, long: 0, name: "Timisoara", countryCode: "RO"),City(lat: 0, long: 0, name: "Moscow", countryCode: "RU"), City(lat: 0, long: 0, name: "Paris", countryCode: "FR")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for city in CityManager.shared.cities {
            weatherHandler.weatherForCity(city: city) { (succes) in
                let weatherData = city.weatherData.first
                weatherData?.printWeatherData()
                self.collectionView.reloadData()
            }
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 25)/2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 8, 0, 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CityManager.shared.cities.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cities = CityManager.shared.cities
        if indexPath.row < cities.count {
            let detailedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedViewController") as! DetailedViewController
            detailedViewController.itemIndex = indexPath
            present(detailedViewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == CityManager.shared.cities.count {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCityCollectionViewCell.reuseIdentifier, for: indexPath) as! AddCityCollectionViewCell
            return addCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as! ListCollectionViewCell
            
            cell.cityNameLabel.text = CityManager.shared.cities[indexPath.row].name
            if let currentTemperature = CityManager.shared.cities[indexPath.row].weatherData.first {
                cell.temperature = Int(round(currentTemperature.value.value))
                cell.mainConditionID = currentTemperature.conditionID
            }
            return cell
        }
    }
}
