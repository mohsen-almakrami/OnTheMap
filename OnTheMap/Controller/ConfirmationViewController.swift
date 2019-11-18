//
//  ConfirmationViewController.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 18/11/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import UIKit
import MapKit


class ConfirmationViewController: UIViewController, MKMapViewDelegate {

    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let lat = CLLocationDegrees(StudentLocationAPI.Constants.latitude)
        let long = CLLocationDegrees(StudentLocationAPI.Constants.longitude)
        let userlocationString = StudentLocationAPI.Constants.mapString
        
        let coor = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coor
        annotation.title = userlocationString
        
        
        let mapSpan = MKCoordinateSpan(latitudeDelta: lat, longitudeDelta: long)
        let region = MKCoordinateRegion(center: coor, span: mapSpan)
        self.mapView.setRegion(region, animated: true)
        
        
        
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        
        if  StudentLocationAPI.Constants.objectId == ""  {
            
            StudentLocationAPI.postLocation { (success, error, objectId) in
                if error != nil {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "POSTING ERROR", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
                
                
                if success == true {
                    
                    DispatchQueue.main.async {
                        StudentLocationAPI.Constants.objectId = objectId ?? ""
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                    
                }
                
                
            }
            
            
        } else {
            
            StudentLocationAPI.updateStudentInfo(objectID: StudentLocationAPI.Constants.objectId) { (success, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "UPDATE ERROR", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
                if success == true {
                    
                    DispatchQueue.main.async {
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
                
            }
            
        }
        
        
    }
    
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
