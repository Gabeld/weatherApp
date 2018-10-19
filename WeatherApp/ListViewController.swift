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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        collectionView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func didBecomeActive(notification: NSNotification!) {
        // do whatever you want when the app is brought back to the foreground
        for city in CityManager.shared.cities {
            weatherHandler.currentWeatherForCity(city: city) { (succes) in
                self.weatherHandler.weatherForCity(city: city)
                self.collectionView.reloadData()
            }
        }
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        NotificationCenter.default.removeObserver(self, name: nil, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for city in CityManager.shared.cities {
            weatherHandler.currentWeatherForCity(city: city) { (succes) in
                self.weatherHandler.weatherForCity(city: city)
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
        return UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
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
            cell.longPressAction = {cell in
                let alertVC = UIAlertController(title: "\(cell.cityNameLabel.text ?? "")", message: "Are you sure you want to delete the city?", preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                    if let indexPath = collectionView.indexPath(for: cell) {
                        CityManager.shared.cities.remove(at: indexPath.row)
                        collectionView.deleteItems(at: [indexPath])
                    }
                }
                alertVC.addAction(cancelAction)
                alertVC.addAction(deleteAction)
                self.present(alertVC, animated: true, completion: nil)
            }
            
            cell.cityNameLabel.text = CityManager.shared.cities[indexPath.row].name
            if let currentTemperature = CityManager.shared.cities[indexPath.row].weatherData.first {
                cell.temperature = Int(round(currentTemperature.avgTemp.value))
                cell.mainConditionID = currentTemperature.conditionID
            } else {
                cell.temperature = 0
                cell.temperatureLabel.text = "-.-"
                cell.imageView.image = nil
            }
            return cell
        }
    }
}
