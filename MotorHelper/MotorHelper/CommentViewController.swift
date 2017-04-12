//
//  CommentViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 05/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseAuth
import FirebaseDatabase
import ReverseExtension

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid

    var storeID: String?
    var sendName: String?
    var sendPhone: String?
    var sendAddress: String?

    var comments: [Comment] = []

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var commentsList: UITableView!
    @IBOutlet weak var commentsTextfield: UITextField!
    @IBOutlet weak var phone: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        storeName.text = sendName ?? "no value"
        phone.text = sendPhone ?? "NO"
        address.text = sendAddress ?? "QQ 沒傳進來"

        commentsList.re.dataSource = self
        commentsList.re.delegate = self

        setUp()
        getComments()

        commentsList.rowHeight = UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell
        else { return UITableViewCell() }

//        cell.userComment.text = comments[indexPath.row].commentContent
        cell.userComment.text = "\(indexPath.row)"
        cell.userID.text = comments[indexPath.row].userID
        return cell
    }

    func setUp() {
        let commentDetailNib = UINib(nibName: CommentTableViewCell.identifier, bundle: nil)
        commentsList.register(commentDetailNib, forCellReuseIdentifier: CommentTableViewCell.identifier)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func getComments() {
        ref = FIRDatabase.database().reference()
        ref?.child("comments").child(storeID!).observeSingleEvent(of: .value, with: { (snapshot) in
            for childSnap in snapshot.children.allObjects {
                guard
                    let snap = childSnap as? FIRDataSnapshot
                    else { return }
                print(snap)
                if let snapshotValue = snapshot.value as? NSDictionary,
                    let snapVal = snapshotValue[snap.key] as? [String:String] {
                    let userID = snapVal["userID"]
                    let userComment = snapVal["userComment"]
                    let comment = Comment(userID: userID!, commentContent: userComment!)
                    self.comments.append(comment)
                }
            }
            self.commentsList.reloadData()
        })
    }

    @IBAction func submitBtn(_ sender: Any) {
        let comment = Comment(userID: userID ?? "Guest", commentContent: commentsTextfield.text!)

        if commentsTextfield.text?.characters.count == 0 {
            print("nil")
        } else {
            self.comments.append(comment)

            let sendData = ["userID": "\(comment.userID)",
                            "userComment": "\(comment.commentContent)"]
            ref = FIRDatabase.database().reference()
            ref?.child("comments").child(storeID!).childByAutoId().setValue(sendData)
            commentsTextfield.text = ""
            commentsList.beginUpdates()
//            commentsList.reloadData()
            commentsList.re.insertRows(at: [IndexPath(row: comments.count - 1, section: 0)], with: .automatic)
            commentsList.endUpdates()

        }
    }

    // close keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
