//
//  AddStoreViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 13/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseDatabase
import FirebaseAuth
import FirebaseAnalytics

protocol buttonIsClick: class {
    func detectIsClick()
}

class AddStoreViewController: UIViewController {

    weak var delegate: buttonIsClick?
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid

    @IBOutlet weak var storePhoneNumber: UITextField!
    @IBOutlet weak var storeAddressTextfield: UITextField!
    @IBOutlet weak var storeNameTextfield: UITextField!
    @IBOutlet weak var storeRate: CosmosView!
    @IBOutlet weak var storeComments: UITextView!
    @IBOutlet weak var submitStore: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        storeNameTextfield.placeholder = "請輸入車行名稱(必填)"
        storeAddressTextfield.placeholder = "請輸入車行地址(必填)"
        storePhoneNumber.keyboardType = .numberPad
        storePhoneNumber.clearButtonMode = .whileEditing
        storePhoneNumber.placeholder = "請輸入車行電話"
        storeComments.placeholderText = "請留下您的評論"
        submitStore.layer.cornerRadius = 15

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    @IBAction func submitBtn(_ sender: Any) {
        ref = FIRDatabase.database().reference()

        if storeNameTextfield.text?.characters.count != 0 && storeAddressTextfield.text?.characters.count != 0 {
            let sendStoreInfo = ["address": "\(storeAddressTextfield.text!)",
                "phoneNumber": "\(storePhoneNumber.text!)",
                "storeName": "\(storeNameTextfield.text!)"]
            let sendStoreComment = ["userID": "\(userID!)",
                "userComment": "\(storeComments.text!)"]
            ref?.child("stores").childByAutoId().setValue(sendStoreInfo, withCompletionBlock: { ( _, snap) in
                print(snap)
                snap.observeSingleEvent(of: .value, with: { (_) in
                    print(snap.key)
                    self.ref?.child("comments").child(snap.key).childByAutoId().setValue(sendStoreComment)
                    print("touch star is : \(self.storeRate.rating)")
                    let sendScore = ["\(self.userID!)": "\(self.storeRate.rating)"]
                    self.ref = FIRDatabase.database().reference()
                    self.ref?.child("rateing").child(snap.key).setValue(sendScore)
                    FIRAnalytics.logEvent(withName: "press_addStoreBtn", parameters: ["New_Store": (self.storeNameTextfield)!])
                })
                DispatchQueue.main.async {
                    self.delegate?.detectIsClick()
                }
            })
            cleanTextField()
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "請完成必填欄位", message: "請按確認繼續", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func cleanTextField() {
        storePhoneNumber.text = ""
        storeAddressTextfield.text = ""
        storeNameTextfield.text = ""
        storeComments.text = ""
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
