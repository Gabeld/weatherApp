//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Alex Dinu on 28/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKLocalSearchCompleterDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    

    var searchCompleter = MKLocalSearchCompleter()
    var searchResult = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
    }
    
    @IBAction func searchTextFieldEdittingChanged(_ sender: Any) {
        tableView.reloadData()
        guard let text = searchTextField.text, searchTextField.text != ""  else {
            return
        }
        searchCompleter.queryFragment = text
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResult = completer.results
        for item in searchResult {
            if !item.title.contains(",") {
                let index = searchResult.index(of: item)
                searchResult.remove(at: index!)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        cell.label.text = searchResult[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResult[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error ) in
            if let placemark = response?.mapItems[0].placemark {
                let name = placemark.name!
                let countryCode = placemark.isoCountryCode!
                let currentCity = City(lat: placemark.coordinate.latitude, long: placemark.coordinate.longitude, name: name, countryCode: countryCode)
                DispatchQueue.main.async {
                    var isPresent = false
                    for city in CityManager.shared.cities {
                        if city == currentCity {
                            isPresent = true
                        }
                    }
                    if isPresent {
                        let errorAC = UIAlertController(title: "Ooops", message: "This city is already listed.", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        errorAC.addAction(okButton)
                        self.present(errorAC, animated: true, completion: nil)
                    } else {
                        CityManager.shared.cities.append(currentCity)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            } else {
                if let error = error {
                    print("Placemark not found \(error)")
                }
            }
        }
        tableView.reloadData()
    }
}
