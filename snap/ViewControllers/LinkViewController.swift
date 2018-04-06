//
//  LinkViewController.swift
//  snap
//
//  Created by Ao Tang on 2018-03-17.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire

class LinkViewController: UIViewController {

    @IBOutlet weak var fb_tf: AkiraTextField!
    
    @IBOutlet weak var tw_tf: AkiraTextField!
    
    @IBOutlet weak var ins_tf: AkiraTextField!
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        revealViewController().rearViewRevealWidth = 275
        MenuButton.target = revealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 119/255, green: 184/255, blue: 239/255, alpha: 1)
        self.hideKeyboardWhenTappedAround()
        setupTextfieldPlaceHoder()
        
        updateAccountInfo()
        // Do any additional setup after loading the view.
    }

    
    func setupTextfieldPlaceHoder() {
        //TODO:
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAccountInfo() {
        print("update Account info")
        let user = UserInfo.getInstace()
        let username = user.getUsername()
        let httpAddress = "http://35.230.95.204:5001/get_social/" + username
        
        self.fb_tf.text = ""
        self.tw_tf.text = ""
        self.ins_tf.text = ""
        Alamofire.request(httpAddress, method: .get).responseString { response in
            if let responseString = response.result.value {
                
                if(responseString.count != 2) {
                    var newString = responseString.prefix(responseString.count - 1)
                    newString = newString.suffix(newString.count - 1)
                    let array = newString.components(separatedBy: ", ")
                    
                    let fb_placeholder = Utils.deleteQuote(s: array[0])
                    if(fb_placeholder.elementsEqual("Null") == true) {
                        self.fb_tf.placeholder = "Setup Your Facebook Account"
                    } else {
                        self.fb_tf.placeholder = fb_placeholder
                    }
                    
                    let tw_placeholder = Utils.deleteQuote(s: array[1])
                    if(tw_placeholder.elementsEqual("Null") == true) {
                        self.tw_tf.placeholder = "Setup Your Twitter Account"
                    } else {
                        self.tw_tf.placeholder = tw_placeholder
                    }
                    let ins_placeholder = Utils.deleteQuote(s: array[2])
                    if(ins_placeholder.elementsEqual("Null") == true) {
                        self.ins_tf.placeholder = "Setup Your Instagram Account"
                    } else {
                        self.ins_tf.placeholder = ins_placeholder
                    }
                    
                    print(array)
                }
                
            }
    }
    }
    @IBAction func updateAccountAction(_ sender: Any) {
        //TODO:
        print("update button pressed")
        
        let user = UserInfo.getInstace()
        let username = user.getUsername()
        var facebook = fb_tf.text!
        var twitter = tw_tf.text!
        var instagram = ins_tf.text!
        
        if(facebook.elementsEqual("") == true) {
            facebook = self.fb_tf.placeholder!
        }
        if(twitter.elementsEqual("") == true) {
            twitter = self.tw_tf.placeholder!
        }
        if(instagram.elementsEqual("") == true) {
            instagram = self.ins_tf.placeholder!
        }
        let httpAddress = "http://35.230.95.204:5001/update_social/" + username
        let headers = ["facebook": facebook,
                       "twitter": twitter,
                       "instagram": instagram]
        print("header is:", headers)
        Alamofire.request(httpAddress, method: .post, headers: headers).responseString { response in
            if let res = response.result.value {
                print("The response is:", res)
                if(res.elementsEqual("Success")) {
                    //TODO ALERT
                    self.updateAccountInfo()
                }
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
