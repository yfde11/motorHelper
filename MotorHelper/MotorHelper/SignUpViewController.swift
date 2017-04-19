//
//  SignUpViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 18/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var pwdAuth: UITextField!
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
        pwdAuth.placeholder = "Enter password again"
        pwdAuth.isSecureTextEntry = true
        pwdAuth.clearButtonMode = .whileEditing

    }
    @IBAction func signUp(_ sender: Any) {
        if mail.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let providedEmailAddress = mail.text
            let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
            if isEmailAddressValid {
                if pwd.text == pwdAuth.text {
                    createUser()
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Please check your password right", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "Please enter a correct mail", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func createUser() {
        FIRAuth.auth()?.createUser(withEmail: mail.text!, password: pwd.text!) { ( _, error) in
            if error == nil {
                print("You have successfully signed up")
                FIRAnalytics.logEvent(withName: kFIREventSignUp, parameters: nil)
                //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
                self.present(vc!, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
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

    @IBAction func toLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func toResetPwd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPWDViewController")
        self.present(vc!, animated: true, completion: nil)

    }
}
