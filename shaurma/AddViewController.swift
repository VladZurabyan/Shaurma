//
//  AddViewController.swift
//  shaurma
//
//  Created by Admin on 8/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class AddViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var mapViewButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var saveButton: UIButton!

    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        
    }

    // MARK: Button Settings
    func configuration() {
        mapViewButton.layer.cornerRadius = 3
        mapViewButton.clipsToBounds = true
        saveButton.isEnabled = false
        saveButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        locationText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc private func textFieldChanged() {
        
        var string = locationText.text
        string = string?.replacingOccurrences(of: " ", with: "", options: .regularExpression)
        if string?.count != 0 {
            saveButton.isEnabled = true
            saveButton.setTitleColor(.black, for: .normal)
        }else {
            saveButton.isEnabled = false
            saveButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        }
    }
    
    //MARK: getLocation
    @IBAction func getLocation(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addViewController = storyboard.instantiateViewController(identifier: "getLocation") as! ViewController
        self.present(addViewController, animated: true)
        
        addViewController.addButton.isHidden = true
        addViewController.search.isHidden = true
        addViewController.locationTapped.isHidden = true
        addViewController.doneButton.isHidden = false
        addViewController.mapPinImage.isHidden = false
        addViewController.currentAdress.isHidden = false
        addViewController.mapViewControllerDelegate = self
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    //MARK: ImagePickerController
    @IBAction func ImagePickerController(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
    }
    
    
}


//MARK: Extension ImagePickerController
extension AddViewController: UIImagePickerControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        photo.image = info[.editedImage] as? UIImage
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: Extension CloseKeyboard
extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddViewController: ViewControllerDelegate {
    func getAddress(_ address: String?) {
        locationText.text = address
        saveButton.isEnabled = true
        saveButton.setTitleColor(.black, for: .normal)
        
}
}
