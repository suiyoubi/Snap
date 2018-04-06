//
//  LeftMenuViewController.swift
//  snap
//
//  Created by Ao Tang on 2018-03-10.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var menuListNameArray:Array = [String]()
    var iconImageArray:Array = [UIImage]()
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuListNameArray = ["Home", "Link your Account", "Gallery", "Logout"]
        iconImageArray = [UIImage(named: "home")!, UIImage(named: "link")!,UIImage(named: "gallery")!,UIImage(named: "settings")!,UIImage(named: "logout")!]
        // Do any additional setup after loading the view.
        
        setupUserInfo()
    }

    func setupUserInfo() {
        let user = UserInfo.getInstace()
        usernameLabel.text = user.getUsername()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuListNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.icon.image = iconImageArray[indexPath.row]
        cell.labelName.text! = menuListNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        //let mainViewController:MainViewController =
        
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        print(cell.labelName.text!)
        if cell.labelName.text! == "Home" {
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealViewController.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.labelName.text! == "Gallery" {
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealViewController.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.labelName.text! == "Link your Account" {
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "LinkViewController") as! LinkViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealViewController.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.labelName.text! == "Logout" {
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"Cancel\" alert occured.")
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Logout", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"Logout\" alert occured.")
                let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(newViewController, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
