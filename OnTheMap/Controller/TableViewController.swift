//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 16/11/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    
    var studentLocation = [StudentLocation]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentsData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    @IBAction func refreshItemButton(_ sender: UIBarButtonItem) {
        
        self.studentLocation.removeAll()
        self.loadStudentsData()
        
    }
    
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        
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
    
    @IBAction func addNewLocationItemButton(_ sender: UIBarButtonItem) {
  

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
    
    
    
    
    private func loadStudentsData() {
        
        let activityIndicator = UIViewController.activateSpinner(onView: self.tableView)
        StudentLocationAPI.loadUsers { (result, error) in
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "DOWNLOAD ERROR", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    UIViewController.deactivateSpinner(spinner: activityIndicator)
                    return
                }

            }
            guard let result = result else {
                return
            }

            for i in 0..<result.results.count {
                let user = result.results[i]

                let student = StudentLocation(objectId: user.objectId, uniqueKey: user.uniqueKey, firstName: user.firstName, lastName: user.lastName, mapString: user.mapString, mediaURL: user.mediaURL, createdAt: user.createdAt, updatedAt: user.updatedAt, latitude: user.latitude, longitude: user.longitude)
                self.studentLocation.append(student)
                DispatchQueue.main.async {
                    UIViewController.deactivateSpinner(spinner: activityIndicator)
                    self.tableView.reloadData()
                }

            }
        }
    }
    
}


    // MARK: - Table view data source
extension TableViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?
        cell?.imageView?.image = UIImage(named: "icon_pin")
        
        if (studentLocation[indexPath.row].firstName) != "" {
            if (studentLocation[indexPath.row].lastName != "") {
                cell?.textLabel?.text = "\(studentLocation[indexPath.row].firstName) \(studentLocation[indexPath.row].lastName)"
            } else {
                cell?.textLabel?.text = "\(studentLocation[indexPath.row].firstName)"
            }
        } else {
            cell?.textLabel?.text = "Student Name Unknown"
        }
        
        if (studentLocation[indexPath.row].mediaURL) != "" {
            cell?.detailTextLabel?.text = "\(studentLocation[indexPath.row].mediaURL)"
        } else {
            cell?.detailTextLabel?.text = "No Student URL Provided"
        }
        
    
        return cell!
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           let cellHeight: CGFloat = 50
           return cellHeight
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocation[indexPath.row]
        if student.mediaURL != "" {
            if UIApplication.shared.canOpenURL(URL(string: student.mediaURL)!) {
                UIApplication.shared.open(URL(string: student.mediaURL)!, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "URL Won't Open", message: "This URL is Not Valid and Won't Open", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "URL not valid", message: "Student's provided URL information contains illegal characters or spaces and will not open.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
