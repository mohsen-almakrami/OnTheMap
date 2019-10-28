//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 29/02/1441 AH.
//  Copyright © 1441 Mohsen Almakrami. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    @IBAction func logoutBarButtonItemPressed(_ sender: UIBarButtonItem) {
        
        try! App.keychain?.remove("token")
        UIApplication.setRootView(LoginViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
