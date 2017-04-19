//
//  LogInViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 27/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pwd: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    func setUp() {
        mail.placeholder = "E-mail"
        mail.keyboardType = .emailAddress
        mail.clearButtonMode = .whileEditing

        pwd.placeholder = "Password"
        pwd.isSecureTextEntry = true
        pwd.clearButtonMode = .whileEditing

    }

    @IBAction func logIn(_ sender: Any) {
        if mail.text == "" || self.pwd.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let providedEmailAddress = mail.text
            let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
            if isEmailAddressValid {
                sendToFirebase()
            } else {
                let alertController = UIAlertController(title: "Error", message: "Please enter a correct mail", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func sendToFirebase() {
        FIRAuth.auth()?.signIn(withEmail: mail.text!, password: pwd.text!, completion: { (_, error) in
            if error == nil {
                print("登入成功")
                FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
                self.present(vc!, animated: true, completion: nil)
            } else {
                // 提示用戶從 firebase 返回了一個錯誤。
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }

    func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))

            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    @IBAction func toSignUpPage(_ sender: Any) {
        //SignUpViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func toResetPwdPage(_ sender: Any) {
        //ResetPWDViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPWDViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func anonymous(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        self.present(vc!, animated: true, completion: nil)
    }
}
