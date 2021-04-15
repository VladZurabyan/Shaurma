//
//  ViewController.swift
//  shaurma
//
//  Created by Admin on 8/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

protocol ViewControllerDelegate {
    func getAddress(_ address: String!)
    func lat(_ lat: Double!)
    func long(_ long: Double!)
}

class ViewController: UIViewController, GMSMapViewDelegate, UITextFieldDelegate {
    
    
    
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var mapViewControllerDelegate: ViewControllerDelegate?
    let locationManager = CLLocationManager()
    let currentLocationMarker = GMSMarker()
    var chosenPlace: MyPlace?
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    let marker=GMSMarker()
    
    var previewDemoData = [
        (title: "Tumanyan Shaurma", img: #imageLiteral(resourceName: "3"),  location: "5"),
        (title: "Gagat", img: #imageLiteral(resourceName: "3"),  location: "Erevan"),
        (title: "Shurma", img: #imageLiteral(resourceName: "3"),  location: "Erevan"),
    ]
    
    var markerView: [MarkerView] = []

    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var locationTapped: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var currentAdress: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBAction func locationTapped(_ sender: Any) {
        gotoPlaces()
    }
    
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()

    }
    
   

    // MARK: gotoPalces || searchPlaces
    func gotoPlaces() {
        search.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    func configuration() {
        // Map configuration
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        self.mapView.delegate = self
        //mapView.camera = GMSCameraPosition.camera(withTarget: locationManager.location!.coordinate, zoom: 15)
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        markerPreviewView=MarkerPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        //showPartyMarkers(lat: (locationManager.location?.coordinate.latitude)!, long: (locationManager.location?.coordinate.longitude)!)
        // Button configuration
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addButton.layer.cornerRadius = 5
        addButton.clipsToBounds = true
        doneButton.isHidden = true
        mapPinImage.isHidden = true
        currentAdress.isHidden = true
        
    }
    
    
    // MARK: MapView: GMSMarker: Configuration
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
           guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
           let data = previewDemoData[customMarkerView.tag]
        markerPreviewView.setData(title: data.title, img: data.img)
           return markerPreviewView
       }
       
       func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
           guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
           let tag = customMarkerView.tag
           markerTapped(tag: tag)
       }
       
       func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
           guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
           let img = customMarkerView.img!
           let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
           marker.iconView = customMarker
       }
    
       func showPartyMarkers(lat: Double, long: Double) {
       // mapView.clear()
        
//       let storyboard = UIStoryboard(name: "Main", bundle: nil)
//               guard let vc = storyboard.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController else { return }
//        vc.latitude = lat
//        vc.longitude = long
        
        
        
        
        
        for i in 0..<previewDemoData.count {

           let marker=GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[i].img, borderColor: UIColor.darkGray, tag: i)
               marker.iconView=customMarker
            let randInt = i
               if randInt == 0 {
                marker.position = CLLocationCoordinate2D(latitude: 40.866842,  longitude: 45.137793)
               } else if randInt == 1 {
                   marker.position = CLLocationCoordinate2D(latitude: 40.897851,  longitude: 45.150041)
               } else if randInt == 2 {
                   marker.position = CLLocationCoordinate2D(latitude: 40.889328,  longitude: 45.150293)
               } else if randInt == 3 {
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                print("\(lat), \(long)")
               } else {
                marker.position = CLLocationCoordinate2D(latitude: 50.0, longitude: 60.0)
            }
               marker.map = self.mapView
           }
        
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {

      let geocoder = GMSGeocoder()
      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else { return }
        self.currentAdress.text = lines.joined(separator: "\n")
        UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
        }
      }
    }
    
    // MARK: Action to my location
    @objc func btnMyLocationAction() {
        let location: CLLocation? = mapView.myLocation
        if location != nil {
            mapView.animate(toLocation: (location?.coordinate)!)
        }
    }
    
    // MARK: Tap to open detail view controller
    @objc func markerTapped(tag: Int) {
        let v=DetailViewController()
        v.passedData = previewDemoData[tag]
        self.present(v, animated: true, completion: nil)
    }
    
    // MARK: Preview marker view
    var markerPreviewView: MarkerPreviewView = {
            let v=MarkerPreviewView()
            return v
        }()
        
    
    // MARK: DoneButtonSettings
    @IBAction func dismissDoneButton(_ sender: Any) {
        mapViewControllerDelegate?.getAddress(currentAdress.text)
        
        // address to Coordinate
        let geocoder = CLGeocoder()
               let address = currentAdress.text!
                             geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                                 if((error) != nil){
                                    let alert = UIAlertController(title: "Error", message: "invalid location", preferredStyle: .alert)
                                    let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                    alert.addAction(alertAction)
                                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                                 }
                                if let placemark = placemarks?.first {
                                    let textToCoordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                                    self.latitude = textToCoordinates.latitude
                                    self.longitude = textToCoordinates.longitude
                                    print("\(self.latitude), \(self.longitude)")
                                    self.mapViewControllerDelegate?.lat(self.latitude)
                                    self.mapViewControllerDelegate?.long(self.longitude)
                                 }
                             })
        
        
        
        
        
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: Extension
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      switch status {
      case .restricted:
        print("Location access was restricted.")
      case .denied:
        print("User denied access to location.")
        // Display the map using the default location.
        mapView.isHidden = false
      case .notDetermined:
        print("Location status not determined.")
      case .authorizedAlways: fallthrough
      case .authorizedWhenInUse:
        print("Location status is OK.")
      @unknown default:
        fatalError()
      }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      locationManager.stopUpdatingLocation()
      print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)

        if mapView.isHidden {
          mapView.isHidden = false
          mapView.camera = camera
        } else {
          mapView.animate(to: camera)
          showPartyMarkers(lat: lat, long: long)
          
          locationManager.stopUpdatingLocation()
        }
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(String(describing: place.name))")
//        dismiss(animated: true, completion: nil)
//
//        self.mapView.clear()
//        self.search.text = place.name
//
//        let cord2D = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//
//
//        let marker = GMSMarker()
//        marker.position = cord2D
//        marker.title = place.name
//
//
//        let markerImage = UIImage(named: "icon-2")!
//        let marderView = UIImageView(image: markerImage)
//        marker.iconView = marderView
//        marker.map = self.mapView
//
//        self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        showPartyMarkers(lat: lat, long: long)
      
        
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        mapView.camera = camera
        search.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, loc: place.formattedAddress!, lat: lat, long: long)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        //marker.title = "\(String(describing: place.name))"
        marker.title = "\(place.formattedAddress!)"
        marker.map = mapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension ViewController {
    
  func  mapView ( _ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocodeCoordinate (position.target)
  }
}


