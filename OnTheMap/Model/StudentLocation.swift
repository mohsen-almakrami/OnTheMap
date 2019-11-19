//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 04/03/1441 AH.
//  Copyright © 1441 Mohsen Almakrami. All rights reserved.
//

import Foundation


var mainUser : Root? = nil


struct Root : Codable {
    let account : Account
    let session : Session
}

struct Account : Codable {
    
    let registered :Bool
    let key : String

}

struct Session: Codable {
    let id : String
    let expiration : String
}

struct SigninError : Codable {
    let status : Int
    let error : String
}

struct StudentLocation: Codable {
    let objectId, uniqueKey, firstName, lastName, mapString, mediaURL, createdAt, updatedAt: String
    let latitude, longitude: Double
}
struct RootResult : Codable {
    let results : [StudentLocation]
}



