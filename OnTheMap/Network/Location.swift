//
//  Location.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 18/11/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class Location {
// FIND STUDENT LOCATION
   class func findStudentLocation(location: String, userURL: String, completionHandlerForFindStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
       
       forwardGeocodeLocationString(locationString: location) { (success, error) in
           if success == true {
            StudentLocationAPI.Constants.mapString = location

               if self.checkURLValidity(userURL: userURL) == true {
                   completionHandlerForFindStudentLocation(true, nil)
               } else {
                   //print(error)
                    print(userURL)
                   completionHandlerForFindStudentLocation(false, "Please enter a valid URL with https://")
               }
           } else {
               completionHandlerForFindStudentLocation(false, error)
               
           }
       }
   }
    class func checkURLValidity(userURL: String?) -> Bool {
        if let urlString = userURL, let url = URL(string: urlString)  {
            //print("can open URL: \(UIApplication.shared.canOpenURL(url))")
            if UIApplication.shared.canOpenURL(url) == true {
                StudentLocationAPI.Constants.mediaURL = userURL ?? ""
                return true
            }
        }
        return false
    }
   
    class func forwardGeocodeLocationString(locationString: String, _ completionHandlerForGeocoder: @escaping (_ success: Bool, _ error: String?) -> Void) {
       CLGeocoder().geocodeAddressString(locationString) { (result, error) in
           if error != nil {
               completionHandlerForGeocoder(false, "Please Enter a City, Address, Postal Code, or Intersection")
               return
           }
           if let location = result, let coordinate = location[0].location?.coordinate {
            StudentLocationAPI.Constants.latitude = coordinate.latitude
            StudentLocationAPI.Constants.longitude = coordinate.longitude
               completionHandlerForGeocoder(true, nil)
           }
       }
   }
   

}
