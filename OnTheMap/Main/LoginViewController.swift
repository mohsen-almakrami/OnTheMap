//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 29/02/1441 AH.
//  Copyright © 1441 Mohsen Almakrami. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    //MARK:- Outlets
    
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()



    }
    

    //MARK:- Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextFieldOutlet.text else {return}
        
        try! App.keychain?.set("token", key: "token")
        UIApplication.setRootView(MainNavigationController.instantiate(from: .Main))
        
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        
        
    }
    
   
}
