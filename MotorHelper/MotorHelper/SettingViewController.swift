//
//  SettingViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 02/05/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI

class SettingViewController: UIViewController {

    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var changePWDBtn: UIButton!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var request: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var newPWD: UITextField!
    @IBOutlet weak var newPWDConfirm: UITextField!
    @IBOutlet weak var oldPWD: UITextField!

    let userMail = FIRAuth.auth()?.currentUser?.email
    override func viewDidLoad() {
        super.viewDidLoad()
        if userMail != nil {
            setUpLogOut()
            helloLabel.text = "\(userMail!), 您好"
        } else {
            setUpLogin()
            helloLabel.text = "您尚未登入，請登入"
        }
    }
    func setUpLogin() {
        logInBtn.isHidden = false
        logOutBtn.isHidden = true
        request.isHidden = true
        changePWDBtn.isHidden = true
        newPWD.isHidden = true
        newPWDConfirm.isHidden = true
        oldPWD.isHidden = true
        logInBtn.layer.cornerRadius = 10
    }
    func setUpLogOut() {
        logInBtn.isHidden = true
        logOutBtn.isHidden = false
        request.isHidden = false
        changePWDBtn.isHidden = false
        newPWD.isHidden = true
        newPWDConfirm.isHidden = true
        oldPWD.isHidden = true
        changePWDBtn.layer.cornerRadius = 10
        logInBtn.layer.cornerRadius = 10
        logOutBtn.layer.cornerRadius = 10
        request.layer.cornerRadius = 10
    }

    @IBAction func sendRequest(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController()
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    @IBAction func changePWD(_ sender: Any) {
        if changePWDBtn.titleLabel?.text == "更改密碼" {
            newPWD.isHidden = false
            newPWD.isSecureTextEntry = true
            newPWDConfirm.isHidden = false
            oldPWD.isHidden = false
            oldPWD.isSecureTextEntry = true
            newPWDConfirm.isSecureTextEntry = true
            changePWDBtn.setTitle("送出", for: .normal)
        } else {
            if newPWD.text == "" || newPWDConfirm.text == "" {
                let sendMailErrorAlert = UIAlertController(title: "新密碼有誤", message: "請重新輸入正確新密碼", preferredStyle: .alert)
                sendMailErrorAlert.addAction(UIAlertAction(title: "確定", style: .default) { _ in })
                self.present(sendMailErrorAlert, animated: true) {}
            } else {
                changePWD()
            }
        }
    }
    @IBAction func logOut(_ sender: Any) {
        setUpLogin()
        helloLabel.text = "您已登出"
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func logIn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    func changePWD() {
        if newPWD.text == newPWDConfirm.text {
            updatePassword(with: newPWD.text!, email: (FIRAuth.auth()?.currentUser?.email!)!, currentPassword: oldPWD.text!, completion: { ( error) in
                if error != nil {
                    self.newPWD.text = ""
                    self.newPWDConfirm.text = ""
                    self.oldPWD.text = ""
                    let sendMailErrorAlert = UIAlertController(title: "Error", message: "請確認輸入的舊密碼正確", preferredStyle: .alert)
                    sendMailErrorAlert.addAction(UIAlertAction(title: "確定", style: .default) { _ in })
                    self.present(sendMailErrorAlert, animated: true) {}
                } else {
                    self.newPWD.text = ""
                    self.newPWDConfirm.text = ""
                    self.oldPWD.text = ""
                    self.newPWD.isHidden = true
                    self.newPWDConfirm.isHidden = true
                    self.oldPWD.isHidden = true
                    self.changePWDBtn.setTitle("更改密碼", for: .normal)
                }
            })
        } else {
            let sendMailErrorAlert = UIAlertController(title: "新密碼有誤", message: "請重新輸入正確新密碼", preferredStyle: .alert)
            sendMailErrorAlert.addAction(UIAlertAction(title: "確定", style: .default) { _ in })
            self.present(sendMailErrorAlert, animated: true) {}
        }
    }

    typealias UpdatePasswordResult = (_ error: Error?) -> Void
    func updatePassword(with newPassword: String, email: String, currentPassword: String, completion: @escaping UpdatePasswordResult) {
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: currentPassword)
        FIRAuth.auth()?.currentUser?.reauthenticate(with: credential, completion: { (error) in
            if error != nil {
                print(error ?? "")
                completion(error)
                return
            }
            FIRAuth.auth()?.currentUser?.updatePassword(newPassword, completion: { (error) in
                if error != nil {
                    print(error ?? "")
                    completion(error)
                    return
                }
                completion(nil)
            })
        })
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["y19938222@gmail.com"])
        mailComposeVC.setSubject("MotoHelper意見回饋")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "無法發送信件", message: "您的手機沒有安裝mail相關軟體，請設定好後再使用", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "確定", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true) {}
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("取消送出")
        case MFMailComposeResult.sent.rawValue:
            print("送出成功")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}
