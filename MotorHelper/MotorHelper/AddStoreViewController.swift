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

class AddStoreViewController: UIViewController {
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid

    @IBOutlet weak var storePhoneNumber: UITextField!
    @IBOutlet weak var storeAddressTextfield: UITextField!
    @IBOutlet weak var storeNameTextfield: UITextField!
    @IBOutlet weak var storeRate: CosmosView!
    @IBOutlet weak var storeComments: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        storeNameTextfield.placeholder = "請輸入車行名稱(必填)"
        storeAddressTextfield.placeholder = "請輸入車行地址(必填)"
        storePhoneNumber.keyboardType = .numberPad
        storePhoneNumber.clearButtonMode = .whileEditing
        storePhoneNumber.placeholder = "請輸入車行電話"

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @IBAction func submitBtn(_ sender: Any) {
        ref = FIRDatabase.database().reference()
        let key = UUID().uuidString
        let sendStoreInfo = ["address": "\(storeAddressTextfield.text)",
                        "phoneNumber": "\(storePhoneNumber.text)",
                        "storeName": "\(storeNameTextfield.text)"]
        let sendStoreComment = ["userID": "\(FIRAuth.auth()?.currentUser?.uid)",
                                "userComment": "\(storeComments.text)"]
        if storeNameTextfield.text?.characters.count == 0 && storeAddressTextfield.text?.characters.count == 0 {
            print("nil")
        } else {
            ref?.child("stores").child(key).setValue(sendStoreInfo)
            ref?.child("comments").child(key).setValue(sendStoreComment)

            cleanTextField()
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
