//
//  DirectionsViewCell.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/7/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable
import MapKit

class DirectionsViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var pickupButton: UIButton!
    
    var lat : Double!
    var lon : Double!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        self.layer.cornerRadius = 8
        
        pickupButton.setTitle("", for: .normal)
    
    }

    @IBAction func pickupAction(_ sender: Any) {
        
        let coordinate = CLLocationCoordinate2DMake(self.lat,self.lon)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

