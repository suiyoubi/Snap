//
//  SettingsViewController.swift
//  snap
//
//  Created by Ao Tang on 2018-03-10.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        revealViewController().rearViewRevealWidth = 275
        MenuButton.target = revealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
