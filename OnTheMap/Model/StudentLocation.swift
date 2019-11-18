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



//import RealmSwift
//import SwiftyJSON


//
//class StudentLocations : Object  {
//
//
//    @objc dynamic var objectId : String = ""
//    @objc dynamic var uniqueKey : String = UUID().uuidString
//    @objc dynamic var firstName : String = ""
//    @objc dynamic var lastName : String = ""
//    @objc dynamic var mapString : String = ""
//    @objc dynamic var mediaURL : String = ""
//    @objc dynamic var latitude : Double = 0.0
//    @objc dynamic var longitude : Double = 0.0
//    @objc dynamic var createdAt : String = ""
//    @objc dynamic var updatedAt : String = ""
//   // @objc dynamic var  ACL : ACL
//
//
//    convenience init(objectId: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, updateAt: String,createdAt : String) {
//        self.init()
//        self.objectId = objectId
//        self.uniqueKey = UUID().uuidString
//        self.firstName = firstName
//        self.lastName = lastName
//        self.mapString = mapString
//        self.mediaURL = mediaURL
//        self.latitude = latitude
//        self.longitude = longitude
//        self.createdAt = createdAt
//        self.updatedAt = updateAt
//    }
//
//    convenience init(Dictionary : [String : AnyObject]) {
//        self.init()
//        self.objectId = Dictionary["objectId"] as? String ?? ""
//        self.uniqueKey = Dictionary["uniqueKey"] as? String ?? ""
//        self.firstName = Dictionary["firstName"] as? String ?? ""
//        self.lastName = Dictionary["lastName"] as? String ?? ""
//        self.mapString = Dictionary["mapString"] as? String ?? ""
//        self.mediaURL = Dictionary["mediaURL"] as? String ?? ""
//        self.latitude = Dictionary["latitude"] as? Double ?? 0.0
//        self.longitude = Dictionary["longitude"] as? Double ?? 0.0
//        self.createdAt = Dictionary["createdAt"] as? String ?? ""
//        self.updatedAt = Dictionary["updatedAt"] as? String ?? ""
//    }
//
//    func GetStudentLocationDictionary() -> [String : AnyObject] {
//        var temp : [String : AnyObject] = [:]
//        temp["objectId"] = self.objectId as AnyObject
//        temp["uniqueKey"] = self.uniqueKey as AnyObject
//        temp["firstName"] = self.firstName as AnyObject
//        temp["lastName"] = self.lastName as AnyObject
//        temp["mapString"] = self.mapString as AnyObject
//        temp["mediaURL"] = self.mediaURL as AnyObject
//        temp["latitude"] = self.latitude as AnyObject
//        temp["longitude"] = self.longitude as AnyObject
//        temp["createdAt"] = self.createdAt as AnyObject
//        temp["updatedAt"] = self.updatedAt as AnyObject
//
//        return temp
//    }
//
//
//
//    override class func primaryKey() -> String? {
//        return "uniqueKey"
//    }
//
//    override static func indexedProperties() -> [String] {
//            return ["objectId"]
//    }
//
//
//}




//struct UserRoot : Codable {
//    let user: User
//}
//
//struct AllowedBehaviors : Codable {
//    let allowedBehaviors : [String]
//    enum CodeKeys : String, CodingKey {
//        case allowedBahaviors = "allowed_behaviors"
//    }
//}
//
//struct Email : Codable {
//    let address : String
//    let _verified : Bool
//    let _verification_code_sent : Bool
//}
//
//struct User : Codable {
//    let lastName : String
//    let socialAccounts : [Int]
//    let mailingAddress : String
//    let cohortKeys : [Int]
//    let signature : String
//    let stripeCustomerId : String
//    let facebookId : String
//    let bio : String
//    let registered : Bool
//    let linkedinUrl :String
//    let image : String
//    let _guard : AllowedBehaviors
//    let location : String
//    let key : String
//    let timezone : String
//    let imageUrl : String
//    let nickname : String
//    let websiteUrl : String
//    let occupation : String
//    let sitePreferences : String
//    let firstName : String
//    let jabberId : String
//    let languages : String
//    let badges : [Int]
//    let external_service_password : String
//    let principals : [Int]
//    let enrollments : [Int]
//    let email : Email
//    let externalAccounts : [Int]
//    let coaching_data : String
//    let tags : [Int]
//    let affiliateProfiles : [Int]
//    let hasPassword : Bool
//    let email_preferences : String
//    let _resume : String
//    let employer_sharing : String
//    let memberships : String
//    let zendesk_id : String
//    let googleId : String
//
//    enum CodingKeys : String, CodingKey {
//        case bio,location,key,timezone, nickname,occupation,signature,languages,email,tags
//        case lastName = "last_name"
//        case socialAccounts = "social_accounts"
//        case mailingAddress = "mailing_address"
//        case cohortKeys = "_cohort_keys"
//        case stripeCustomerId = "_stripe_customer_id"
//        case facebookId = "_facebook_id"
//        case registered = "_registered"
//        case linkedinUrl = "linkedin_url"
//        case image = "_image"
//        case _guard = "guard"
//        case imageUrl = "_image_url"
//        case websiteUrl = "website_url"
//        case sitePreferences = "site_preferences"
//        case firstName = "first_name"
//        case jabberId = "jabber_id"
//        case badges = "_badges"
//        case external_service_password
//        case principals = "_principals"
//        case enrollments = "_enrollments"
//        case externalAccounts = "external_accounts"
//        case coaching_data
//        case affiliateProfiles = "_affiliate_profiles"
//        case hasPassword = "_has_password"
//        case email_preferences
//        case _resume
//        case employer_sharing
//        case memberships = "_memberships"
//        case zendesk_id
//        case googleId = "_google_id"
//
//    }
//}
