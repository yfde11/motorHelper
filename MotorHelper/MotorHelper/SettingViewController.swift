//
//  SettingViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 02/05/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import FirebaseAuth
class SettingViewController: UIViewController {

    @IBOutlet weak var logOutBtn: UIButton!

    @IBOutlet weak var logInBtn: UIButton!

    let userID = FIRAuth.auth()?.currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        if userID != nil {
            setUpLogOut()
            setRequestBtn()
        } else {
            setUpLogin()
        }
    }
    func setUpLogin() {
        logInBtn.isHidden = false
        logOutBtn.isHidden = true
        logInBtn.layer.cornerRadius = 10
        logOutBtn.layer.cornerRadius = 10
    }
    func setUpLogOut() {
        logInBtn.isHidden = true
        logOutBtn.isHidden = false
        logInBtn.layer.cornerRadius = 10
        logOutBtn.layer.cornerRadius = 10
    }
    func setRequestBtn() {
        
    }
}
