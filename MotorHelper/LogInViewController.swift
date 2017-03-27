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
    let mail = "y19938222@gmail.com"
    let pwd = "22871230"

    @IBAction func logIn(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: mail, password: pwd, completion: { (_, error) in
            if error == nil {
                print("登入成功")
                //go to next controller
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "oilConsumeNavigationController")
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
