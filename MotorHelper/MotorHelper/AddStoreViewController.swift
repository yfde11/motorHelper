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
            })
        })
        cleanTextField()
        DispatchQueue.main.async {
            self.delegate?.detectIsClick()
        }
        self.navigationController?.popViewController(animated: true)
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
//    private func didTouchCosmos(_ rating: Double) {
//        print("touch star is : \(self.storeRate.rating)")
//        let sendScore = ["\(userID!)": "\(self.storeRate.rating)"]
//        ref = FIRDatabase.database().reference()
//        ref?.child("rateing").child(storeID!).setValue(sendScore)
//    }
}
