//
//  PlaceModel.swift
//  FourSqareClone
//
//  Created by Jinu on 08/11/23.
//

import Foundation
import UIKit
class PlaceModel{
    
    static let sharedInstance = PlaceModel()
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(placeName: String = "", placeType: String = "", placeAtmosphere: String = "", placeImage: UIImage = UIImage()) {
        self.placeName = placeName
        self.placeType = placeType
        self.placeAtmosphere = placeAtmosphere
        self.placeImage = placeImage
    }
}
