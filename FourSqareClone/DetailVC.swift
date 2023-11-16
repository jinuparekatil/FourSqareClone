//
//  DetailVC.swift
//  FourSqareClone
//
//  Created by Jinu on 08/11/23.
//

import UIKit
import MapKit
import ParseCore
class DetailVC: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var placeLatitude = Double()
    
    var placeLongitude = Double()

    
    var chosenPlaceId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDataFromParse()
        detailsMapView.delegate = self
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil{
                let alert = UIAlertController(title: "Error!", message: "Place name/type/atmosphere?", preferredStyle: UIAlertController.Style.alert)
                let okBuutton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okBuutton)
            }else{
                if objects != nil {
                    if objects!.count > 0 {
                        
                        let chosenPlaceObject = objects![0]
                        //OBJECTS
                      
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                            self.detailsNameLabel.text = placeName

                        }
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String{
                            self.detailsTypeLabel.text = placeType

                        }
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String{
                            self.detailsAtmosphereLabel.text = placeAtmosphere

                        }
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.placeLatitude = Double(placeLatitudeDouble)

                            }

                        }
                        if let placeLongiitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                            if let placelongitudeDOuble = Double(placeLongiitude){
                                self.placeLongitude = placelongitudeDOuble

                            }

                        }
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject{
                            imageData.getDataInBackground { data, error in
                                if error != nil{
                                    
                                }else{
                                    if data != nil{
                                        self.detailsImageView.image = UIImage(data: data!)

                                    }
                                }
                            }
                          

                        }
                        
                        //MAP
                        let location = CLLocationCoordinate2D(latitude: self.placeLatitude, longitude: self.placeLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        let  region = MKCoordinateRegion(center: location, span: span)
                        self.detailsMapView.setRegion(region, animated: true)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailsNameLabel.text
                        annotation.subtitle = self.detailsTypeLabel.text
                        self.detailsMapView.addAnnotation(annotation)
                    }

                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId )
        if pinView == nil{
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }else{
            pinView?.annotation = annotation
        }
            return pinView
            
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.placeLongitude != 0.0 && self.placeLatitude != 0.0{
            let requestLocation = CLLocation(latitude: self.placeLatitude, longitude: self.placeLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks{
                    if placemark.count > 0{
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        let launchOption = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOption)
                    }
                }
            }
        }
    }

}
