//
//  Helper.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 16/11/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    let shared = Helper()
    
    private init(){}
    
    static func resetTheAccount(_ key: String) {
        do {
            try App.keychain?.remove(key)
            UIApplication.setRootView(LoginViewController.instantiate(from: .Main))
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
