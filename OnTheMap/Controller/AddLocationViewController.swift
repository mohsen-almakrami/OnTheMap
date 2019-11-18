//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 18/03/1441 AH.
//  Copyright © 1441 Mohsen Almakrami. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    
    
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var urlTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        
        if locationTF.text!.isEmpty || urlTF.text!.isEmpty {
            let alert = UIAlertController(title: nil, message: "Location & URL are required!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            
        } else {
            let userLocation = locationTF.text!
            let userURL = urlTF.text!
            print("dddd\(userURL)")
            
            let activityView = UIViewController.activateSpinner(onView: self.view)
            
            Location.findStudentLocation(location: userLocation, userURL: userURL, completionHandlerForFindStudentLocation: { (success, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Could Not Find Location", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        UIViewController.deactivateSpinner(spinner: activityView)
                    }
                }
                
                if success == true {
                    DispatchQueue.main.async {
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ConfirmationViewController")
                        self.present(controller, animated: true, completion: nil)
                        UIViewController.deactivateSpinner(spinner: activityView)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Invalid URL", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        UIViewController.deactivateSpinner(spinner: activityView)
                    }
                }
            })
        }
    }
    
    

}
