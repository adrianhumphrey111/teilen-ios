//
//  DirectionSectionController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/26/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit
import CoreLocation

class DirectionSectionController : ListSectionController{
    
    var user: User!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}

extension DirectionSectionController {
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        //Get estimation of the height of the cell
        let cellWidth = ((collectionContext?.containerSize.width)! - 20)
        return CGSize(width: cellWidth, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass : String = DirectionsViewCell.reuseIdentifier
        let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
        configureDirectionCell( cell: cell )
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? User
    }
    
    override func didSelectItem(at index: Int) {

    }
    
    func configureDirectionCell(cell: UICollectionViewCell){
        if let cell = cell as? DirectionsViewCell{
            cell.pickupLabel.text = "Pick Up \(self.user.firstName)"
            
            let address = self.user.currentTrip?.startLocation.to_string()
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address!) {
                placemarks, error in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                print("Lat: \(lat), Lon: \(lon)")
                cell.lat = lat
                cell.lon = lon
            }
            
            
        }
    }
    
}
