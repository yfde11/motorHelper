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
        print(storeID ?? "no value")
        storeName.text = sendName ?? "no value"
        phone.text = sendPhone ?? "NO"
        address.text = sendAddress ?? "QQ 沒傳進來"
        commentsList.delegate = self
        commentsList.dataSource = self
        setUp()
        getComments()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentTableViewCell.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell
            else { return UITableViewCell() }
        cell.userComment.text = comments[indexPath.row].commentContent
        cell.userID.text = comments[indexPath.row].userID
        return cell
    }
    func setUp() {
        let commentDetailNib = UINib(nibName: CommentTableViewCell.identifier, bundle: nil)
        commentsList.register(commentDetailNib, forCellReuseIdentifier: CommentTableViewCell.identifier)
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
    }
}
