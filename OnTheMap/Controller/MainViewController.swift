//
//  ViewController.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 29/02/1441 AH.
//  Copyright © 1441 Mohsen Almakrami. All rights reserved.
//

import UIKit
import KeychainAccess
import MapKit


class MainViewController: UIViewController {

    
    let id : String  = {
        if let id = App.keychain?["id"] {
            return id
        }
        return ""
        }()
    
    let key : String = {
        if let key = App.keychain?["key"] {
            return key
        }
        return ""
    }()
    
    var annotations = [MKPointAnnotation]()
    var tempPin = [MKAnnotation]()
    var studentLocation : [StudentLocation] = []
  
    
    
    @IBOutlet weak var addOutlet: UIBarButtonItem!
    @IBOutlet weak var refreshOutlet: UIBarButtonItem!
    @IBOutlet weak var logoutOutlet: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        mapView.delegate = self
        loadStudentsData()
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        StudentLocationAPI.checkForObjectId(StudentLocationAPI.Constants.studentKey) { (success, objectID) in
            if !success {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as UIViewController
                self.present(vc, animated: true, completion: nil)
            } else {
                
                let alert = UIAlertController(title: nil, message: "User \"\(StudentLocationAPI.Constants.firstName) \(StudentLocationAPI.Constants.lastName)\" has already posted a Student Location. Would you like to overwrite their location?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as UIViewController
                    self.present(controller, animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        self.studentLocation.removeAll()
        self.loadStudentsData()
        
    }
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        StudentLocationAPI.logout { (success, error) in
            if error != nil {
                print("logout error")
            } else {
                DispatchQueue.main.async {
                    Helper.resetTheAccount("token")
                }
            }
        }
        
    }
    
    private func loadPins() {
        
        for pin in studentLocation {
            //if pin.mapString != nil || pin.mediaURL != nil {
                let createPin = MKPointAnnotation()
                createPin.title = pin.mapString
                createPin.subtitle = pin.mediaURL
                createPin.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude:pin.longitude)
                self.annotations.append(createPin)
                
           // }
        }
        
        self.mapView.addAnnotations(self.annotations)
    }

    
    private func loadStudentsData() {
        let activityIndicator = UIViewController.activateSpinner(onView: mapView)
        StudentLocationAPI.loadUsers { (result, error) in
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "DOWNLOAD ERROR", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    UIViewController.deactivateSpinner(spinner: activityIndicator)
                }
                return
            }
            guard let result = result else {
                return
            }
            
            for i in 0..<result.results.count {
                let user = result.results[i]
                
                let student = StudentLocation(objectId: user.objectId, uniqueKey: user.uniqueKey, firstName: user.firstName, lastName: user.lastName, mapString: user.mapString, mediaURL: user.mediaURL, createdAt: user.createdAt, updatedAt: user.updatedAt, latitude: user.latitude, longitude: user.longitude)
                self.studentLocation.append(student)
                if i == (result.results.count - 1) {
                    DispatchQueue.main.async {
                        UIViewController.deactivateSpinner(spinner: activityIndicator)
                        self.loadPins()
                    }
                    
                }
            }
        }
    }
}

extension MainViewController : MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}


