//
//  JournalDetailViewController.swift
//  GoJournal
//
//  Created by Jack Wilson on 11/26/18.
//  Copyright © 2018 Jack Wilson. All rights reserved.
//

import UIKit
import GooglePlaces
import AVFoundation

class JournalDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var entryView: UITextView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var lookUpPlaceButton: UIBarButtonItem!
    
    var entryTitle: String!
    var entryLocation: String!
    var entry: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isToolbarHidden = false
        if let entryTitle = entryTitle {
            titleField.text = entryTitle
            self.navigationItem.title = "Edit Entry Title"
        } else {
            self.navigationItem.title = "New Entry Title"
        }
        if let entryLocation = entryLocation {
            locationField.text = entryLocation
        }
        if let entry = entry {
            entryTextView.text = entry
        }
        //enableDisableSaveButton()
        titleField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            entryTitle = titleField.text
            entryLocation = locationField.text
            entry = entryTextView.text
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        imageView.image = selectedImage
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func showAlert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(defaultAction)
//        present(alertController, animated: true, completion: nil)
//    }
    
    
    
    func enableDisableSaveButton() {
        if let titleFieldCount = titleField.text?.count, titleFieldCount > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    
    @IBAction func titleFieldEditingChanged(_ sender: UITextField) {
        enableDisableSaveButton()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
//    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
//        present(imagePicker, animated: true, completion: nil)
//    }
    
//    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//            imagePicker.delegate = self
//            present(imagePicker, animated: true, completion: nil)
//        } else {
//            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
//        }
//    }
    
    
    
    @IBAction func lookUpPlaceButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    

}


extension JournalDetailViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        locationField.text = place.name
        
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
