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
        logInBtn.layer.cornerRadius = 10
    }
    func setUpLogOut() {
        logInBtn.isHidden = true
        logOutBtn.isHidden = false
        request.isHidden = false
        changePWDBtn.isHidden = false
        newPWD.isHidden = true
        newPWDConfirm.isHidden = true
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
            newPWDConfirm.isHidden = false
            changePWDBtn.setTitle("送出", for: .normal)
        } else {
            newPWD.isHidden = true
            newPWDConfirm.isHidden = true
            changePWDBtn.setTitle("更改密碼", for: .normal)
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
        currentUser.updatePassword(newPasswordSecondValue, completion: { (error) in
            newPasswordFirst.value = ""
            newPasswordSecond.value = ""
            if error == nil {
                SCLAlertView().showSuccess("修改成功！", subTitle: "\n已經成功更新您的密碼") // todo
            } else {
                SCLAlertView().showError("哎唷！", subTitle: "\n更新密碼失敗，請稍後再試", colorStyle: Constants.Color.errorColorUInt)
            }
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
