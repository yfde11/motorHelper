//
//  ResetPWDViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 18/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPWDViewController: UIViewController {

    @IBOutlet weak var mail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func reset(_ sender: Any) {
        if self.mail.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.sendPasswordReset(withEmail: mail.text!, completion: { (error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.mail.text = ""
                }
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }

    @IBAction func toLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
        self.present(vc!, animated: true, completion: nil)
    }

    @IBAction func toSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(vc!, animated: true, completion: nil)
    }
}
