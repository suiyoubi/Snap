//
//  ViewController.swift
//  snap
//
//  Created by Ao Tang on 2018-03-08.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var tf_username: LoginTextField!
    @IBOutlet weak var tf_password: LoginTextField!
    
    @IBOutlet weak var lb_message: UILabel!
    
    @IBOutlet weak var bt_login: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lb_message.text = ""
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any) {
        let username = tf_username.text
        let password = tf_password.text
        accountAuthentification(username: username!, password: password!)
    }
    
    func successAction() {
        print("success!")
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    func failAction() {
        print("failed!")
        lb_message.text = "Login Failed"
    }
    func accountAuthentification(username: String, password: String) {
        print("username:", username)
        print("PASSWORD:", password)
        
        
        let httpAddress = "http://104.199.127.227:5001/login_user"
        let headers = ["username": username,
                    "password": password]
       
        Alamofire.request(httpAddress, method: .post, headers: headers).responseString { response in
            if let JSON = response.result.value {
                /*
                var jsonobject = JSON as! [String: AnyObject]
                let origin = jsonobject["origin"] as! String
                let url = jsonobject["url"] as! String
                print("JSON: \(jsonobject)")
                print("IP Address Origin: \(origin)")
                print("url: \(url)")
            */
                print("The response is:", JSON)
                if(JSON.elementsEqual("Pass") == true) {
                    self.successAction()
                } else {
                    self.failAction()
                }
            }
        }
    }
}

