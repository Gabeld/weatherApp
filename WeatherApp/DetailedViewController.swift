//
//  DetailedViewController.swift
//  WeatherApp
//
//  Created by Alex Dinu on 29/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet var detailedCollectionView: UICollectionView!
    
    var itemIndex: IndexPath!
    var viewDidLayoutSubviewsForTheFirstTime = true
    
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
        view.backgroundColor = UIColor.brown
        detailedCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailedCollectionView.scrollToItem(at: itemIndex, at: .right, animated: true)
        detailedCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = detailedCollectionView.bounds
        return CGSize(width: collectionViewSize.width, height: collectionViewSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cities = CityManager.shared.cities
        let mainWeather = cities[indexPath.row].weatherData.first
        let cell = detailedCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailedCollectionViewCell", for: indexPath) as! DetailedCollectionViewCell
        cell.cityNameLabel.text = cities[indexPath.row].name
        cell.mainWeatherIcon.image = #imageLiteral(resourceName: "chanceflurries")
        return cell
    }
}
