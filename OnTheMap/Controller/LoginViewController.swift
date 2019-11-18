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
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
        
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    //MARK:- Actions
    
    fileprivate func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.hidesWhenStopped = true
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextFieldOutlet.text, let password = passwordTextFieldOutlet.text else {
            self.showAlert(title: "Error", message: "Enter an email or a password")
            return
        }
        
        if email == "" || password == "" {
            self.showAlert(title: "Error", message: "Enter an email or a password")
            return
        }
        setupActivityIndicator()
        activityIndicator.startAnimating()
        loginButtonOutlet.isEnabled = false
        
        StudentLocationAPI.signIn(with: email, password) { (data, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                    self.activityIndicator.stopAnimating()
                    self.loginButtonOutlet.isEnabled = true
                    return
                }
            }
            
            StudentLocationAPI.getPublicData()
            DispatchQueue.main.async {
                if let data = data {
                    try! App.keychain?.set(data.session.id, key: "id")
                    try! App.keychain?.set(data.account.key, key: "key")
                }
                self.loginButtonOutlet.isEnabled = true
                self.activityIndicator.stopAnimating()
                try! App.keychain?.set("token", key: "token")
                UIApplication.setRootView(TabBarController.instantiate(from: .Main))
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url)
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)

    }
   
}



