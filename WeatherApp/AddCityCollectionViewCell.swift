//
//  AddCityCollectionViewCell.swift
//  WeatherApp
//
//  Created by Alex Dinu on 27/03/2018.
//  Copyright © 2018 Alex Dinu. All rights reserved.
//

import UIKit

class AddCityCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "AddCityCollectionViewCell"
    
    @IBOutlet var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 7
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 108/255, green: 122/255, blue: 137/255, alpha: 1)
        imageView.image = #imageLiteral(resourceName: "add_icon")
    }
    
}
