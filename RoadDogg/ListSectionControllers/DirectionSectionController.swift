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
import AddressBookUI

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
            
            let address = self.user.currentTrip!.startLocation.to_string()
            print(address)
            CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error)
                    
                }
                if placemarks!.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                    cell.lat = coordinate!.latitude
                    cell.lon = coordinate!.longitude
                    if placemark!.areasOfInterest!.count > 0 {
                        let areaOfInterest = placemark!.areasOfInterest![0]
                        print(areaOfInterest)
                    } else {
                        print("No area of interest found.")
                    }
                    
                }
            })
            
        }
    }
    
}
