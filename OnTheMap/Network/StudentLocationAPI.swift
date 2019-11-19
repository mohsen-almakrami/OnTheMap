//
//  StudentLocationAPI.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 16/11/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import Foundation


class StudentLocationAPI {
    
    struct Constants {
        static let urlStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let urlUdacitySession = "https://onthemap-api.udacity.com/v1/session"
        static var studentKey: String = ""
        static var firstName: String = ""
        static var lastName: String = ""
        static var objectId : String = ""
        static var mapString : String = ""
        static var mediaURL : String = ""
        static var latitude : Double = 0.0
        static var longitude : Double = 0.0
    }
    
    
    struct HTTPMethods {
        static let delete = "DELETE"
        static let post = "POST"
    }
    
    
    class func loadUsers(completion: @escaping (RootResult?, Error?)-> Void ){
        
        let request = URLRequest(url: URL(string: "\(StudentLocationAPI.Constants.urlStudentLocation)?order=-updatedAt&limit=200")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
          if error != nil {
            completion(nil,error)
              return
          }
            do {
                 let response = try JSONDecoder().decode(RootResult.self, from: data)
                completion(response,nil)
                
            } catch {
                completion(nil, NSError(domain: "", code: 232, userInfo: nil))
            }
        }
        task.resume()
    }
    
   class func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: StudentLocationAPI.Constants.urlUdacitySession)!)
        request.httpMethod = StudentLocationAPI.HTTPMethods.delete
        var httpCookie: HTTPCookie? = nil
        let sharedHTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedHTTPCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { httpCookie = cookie }
        }
        if let xsrfCookie = httpCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            if let _ = data?.dropLast(5) {
                completionHandlerForLogout(true, nil)
            } else {
                completionHandlerForLogout(false, "error in logout")
            }
        }
        task.resume()
    }
    
    
    class func signIn(with email: String, _ password: String, completion: @escaping (Root?, Error?)-> Void) {
        
        var request = URLRequest(url: URL(string: StudentLocationAPI.Constants.urlUdacitySession)!)
        request.httpMethod = StudentLocationAPI.HTTPMethods.post
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data?.dropFirst(5) else {return}
            if error != nil { // Handle error…
                completion(nil,error)
                return
            }
            
            do {
                
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
                if parsedResult?.first?.key == "status" {
                    let response = try JSONDecoder().decode(SigninError.self, from: data)
                    let error = NSError(domain: "\(response.error)", code: response.status, userInfo: nil)
                    completion(nil, error)
                }
                
                if parsedResult?.first?.key == "account" || parsedResult?.first?.key == "session" {
                    let response = try JSONDecoder().decode(Root.self, from: data)
                    guard let account = parsedResult?["account"] else {
                        print("account error")
                                   return
                    }
                               
                    if let studentKey = account["key"] as? String {
                        print("studentKey:\(studentKey)")
                        StudentLocationAPI.Constants.studentKey = studentKey
                    }
                    completion(response,nil)
                } else {
                    completion(nil,NSError(domain: "Error", code: 110, userInfo: nil))
                }
            } catch let error {
                print(error.localizedDescription)
                completion(nil,NSError(domain: "Error", code: 100, userInfo: nil))
            }
        }
        task.resume()
    }
    
    
     // MARK: CHECK FOR OBJECT ID
    class func checkForObjectId(_ uniqueKey: String, _ completionHandlerfForCheckForObjectId: @escaping (_ result: Bool, _ objectID:String?) -> Void) { //params UniqueKey from parseClient Constant
        
        
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey=\(uniqueKey)"
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        //request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        //request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            //print(String(data: data!, encoding: .utf8)!)
            
            
            do {
                let parsedResults = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
                
                if let results = parsedResults?["results"] as? [[String: AnyObject]] {
                    
                    if results.isEmpty{
                        completionHandlerfForCheckForObjectId(false,nil)
                    }
                    
                    for result in results {
                        
                        if let objectID = result["objectId"] as? String { //insert objectID from parseClient constants.
                    
                            completionHandlerfForCheckForObjectId(true,objectID)
                            
                        }
                    }
                    
                } else {
                  completionHandlerfForCheckForObjectId(false,nil)
                }
                
                
            } catch let error {
                print("ERror checkForObjectId \(error)")
                
            }
            

            
            
        }
        task.resume()
    }
    
    
    // MARK: POST STUDENT INFO
    class func postLocation(_  completionHandlerfForPostLocation: @escaping (_ success: Bool, _ error: String?, _ objectID:String?) -> Void) {
        
        
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(StudentLocationAPI.Constants.studentKey)\", \"firstName\": \"\(StudentLocationAPI.Constants.firstName)\", \"lastName\": \"\(StudentLocationAPI.Constants.lastName)\",\"mapString\": \"\(StudentLocationAPI.Constants.mapString)\", \"mediaURL\": \"\(StudentLocationAPI.Constants.mediaURL)\",\"latitude\": \(StudentLocationAPI.Constants.latitude), \"longitude\": \(StudentLocationAPI.Constants.longitude)}".data(using: .utf8)
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                print("error in your request")
                completionHandlerfForPostLocation(false,"Error in your request",nil)
                return
            }
            
            guard let data = data else {
                print("no data returned")
                completionHandlerfForPostLocation(false, "Could Not Post Student Location", nil)
                return
            }
            //print(String(data: data, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("status code returned other than 2xx")
                completionHandlerfForPostLocation(false, "Could Not Post Student Location", nil)
                return
            }
            
            guard let parsedResults = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                completionHandlerfForPostLocation(false, "Could Not Post Student Location", nil)
                return
            }
            
            
            if let objectID = parsedResults["objectId"] as? String {
                
                completionHandlerfForPostLocation(true, nil, objectID)
            } else {
                completionHandlerfForPostLocation(false, "Could Not Post Student Location", nil)
            }
            

        }
        task.resume()
    }
    
    // UPDATE STUDENT INFO
    class func updateStudentInfo(objectID: String,  _ completionHandlerfForUpdateStudentInfo: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(StudentLocationAPI.Constants.studentKey)\", \"firstName\": \"\(StudentLocationAPI.Constants.firstName)\", \"lastName\": \"\(StudentLocationAPI.Constants.lastName)\",\"mapString\": \"\(StudentLocationAPI.Constants.mapString)\", \"mediaURL\": \"\(StudentLocationAPI.Constants.mediaURL)\",\"latitude\": \(StudentLocationAPI.Constants.latitude), \"longitude\": \(StudentLocationAPI.Constants.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            guard let data = data else {
                print("no data returned")
                completionHandlerfForUpdateStudentInfo(false, "Could Not Update Student Information.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("status code returned other than 2xx")
                completionHandlerfForUpdateStudentInfo(false, "Could Not Update Student Information.")
                
                return
            }
            
            guard let parsedResults = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                print("parse query error")
                completionHandlerfForUpdateStudentInfo(false, "Could Not Update Student Information.")
                return
            }
            
            //print(String(data: data, encoding: .utf8)!)
            
            if let results = parsedResults["updatedAt"] as? String {
                print(results)
                completionHandlerfForUpdateStudentInfo(true, nil)
            } else {
            // if no results, completion (false, error)
                completionHandlerfForUpdateStudentInfo(false, "Could Not Update Student Information.")
            }
            
        }
        task.resume()
    }
    
    // MARK: GET PUBLIC USER DATA
      class func getPublicData() {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(StudentLocationAPI.Constants.studentKey)")!)
           let session = URLSession.shared
           let task = session.dataTask(with: request) { data, response, error in
               if error != nil { // Handle error...
                   return
               }
               let newData = data?.dropFirst(5)
               
            
            do {
                 let parsedResults = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String:AnyObject]
                   
                   guard let firstName = parsedResults?["first_name"] as? String, let lastName = parsedResults?["last_name"] as? String else {
                       print("first/last name error")
                       return
                   }
                StudentLocationAPI.Constants.firstName = firstName
                StudentLocationAPI.Constants.lastName = lastName
            } catch let error {
                print("Error GetpublicData: \(error.localizedDescription)")
            }
            
            
            
            
               
               
           }
           task.resume()
       }
       
    
}
