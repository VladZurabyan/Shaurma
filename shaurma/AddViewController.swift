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

class AddViewController: UIViewController, UINavigationControllerDelegate{

    
    
    var imageIsChanged = false
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var mapViewButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoButton: UIButton!
    
    
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
        nameText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        registerForKeyboardNotifications()
    }
 
    // MARK: Text field Configuration
    @objc private func textFieldChanged() {
        
        var string = locationText.text
        var name = nameText.text
        
        string = string?.replacingOccurrences(of: " ", with: "", options: .regularExpression)
        name = name?.replacingOccurrences(of: " ", with: "", options: .regularExpression)
        imageIsChanged = true
//        if string?.count != 0 && name?.count != 0 {
//            saveButton.isEnabled = true
//            saveButton.setTitleColor(.black, for: .normal)
//        }else {
//            saveButton.isEnabled = false
//            saveButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
//        }
    }
    
    //MARK: getLocation
    @IBAction func getLocation(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addViewController = storyboard.instantiateViewController(identifier: "getLocation") as! ViewController
        addViewController.modalPresentationStyle = .fullScreen
        self.present(addViewController, animated: true)
        
        
        addViewController.addButton.isHidden = true
        addViewController.search.isHidden = true
        addViewController.locationTapped.isHidden = true
        addViewController.doneButton.isHidden = false
        addViewController.mapPinImage.isHidden = false
        addViewController.currentAdress.isHidden = false
        addViewController.mapViewControllerDelegate = self
        addViewController.previewDemoData.removeAll()
    }
    
    public func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    //MARK: ImagePickerController
    @IBAction func ImagePickerController(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camreIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo-1")
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(camreIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
    }
    
    // MARK: KeyBoard Configuration
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height - 50)
    }
    
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
      
      
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//         guard let vc = storyboard.instantiateViewController(withIdentifier: "getLocation") as? ViewController else { return }
            for obj in (self.navigationController?.viewControllers)! {
                       if obj is ViewController {
             let vc2: ViewController =  obj as! ViewController
                        
                        vc2.previewDemoData.append((title: nameText.text!, img: photo.image!, location: locationText.text!))
                        vc2.showPartyMarkers(lat: latitude, long: longitude)
                        print("\(self.latitude), \(self.longitude)")
                        vc2.marker.map = vc2.mapView
                        print("\(vc2.previewDemoData.count)")
                           _ =
            self.navigationController?.popToViewController(vc2, animated: true)
             break
                       }
                   }
        }
    
@IBAction func close(sender: AnyObject) {
    navigationController?.popToRootViewController(animated: true)
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
        imageIsChanged = true
        dismiss(animated: true) {
            if self.imageIsChanged == true && self.locationText.text?.count != 0 && self.nameText.text?.count != 0 {
                self.saveButton.isEnabled = true
                self.saveButton.setTitleColor(.black, for: .normal)
            }
        }
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
    func lat(_ lat: Double!) {
        self.latitude = lat
    }
    
    func long(_ long: Double!) {
        self.longitude = long
    }
    
    func getAddress(_ address: String!) {
        locationText.text = address
        
        if locationText.text?.count != 0 && nameText.text?.count != 0 {
            saveButton.isEnabled = true
            saveButton.setTitleColor(.black, for: .normal)
        }
    }

}
