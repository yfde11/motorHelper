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
import FirebaseAnalytics
//import ReverseExtension

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: buttonIsClick?
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.email

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
        commentsTextfield.placeholder = "請留下您的評論"

        rating.didTouchCosmos = didTouchCosmos
        rating.didFinishTouchingCosmos = didFinishTouchingCosmos

        commentsList.delegate = self
        commentsList.dataSource = self
        commentsList.separatorStyle = .none

        if userID != nil {
            getRating()
        } else {
            let alertController = UIAlertController(title: "Error", message: "您尚未註冊無法使用此功能", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let jumpAction = UIAlertAction(title: "去註冊", style: .default, handler: { ( _ ) -> Void in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
                self.present(vc!, animated: true, completion: nil)
            })
            alertController.addAction(defaultAction)
            alertController.addAction(jumpAction)
            self.present(alertController, animated: true, completion: nil)

            rating.settings.updateOnTouch = false
            rating.didTouchCosmos = nil
        }

        setUp()
        getComments()
        commentsList.rowHeight = UITableViewAutomaticDimension
        commentsList.estimatedRowHeight = 77
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell
        else { return UITableViewCell() }

        cell.userComment.text = comments[indexPath.row].commentContent
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
            self.moveToLastComment()
        })
    }

    @IBAction func submitBtn(_ sender: Any) {
        let comment = Comment(userID: userID ?? "Guest", commentContent: commentsTextfield.text!)

        if userID != nil {
            if commentsTextfield.text?.characters.count == 0 {
                print("nil")
            } else {
                self.comments.append(comment)
                let sendData = ["userID": "\(comment.userID)",
                    "userComment": "\(comment.commentContent)"]
                ref = FIRDatabase.database().reference()
                ref?.child("comments").child(storeID!).childByAutoId().setValue(sendData)
                FIRAnalytics.logEvent(withName: "WriteComment", parameters: nil)
                commentsTextfield.text = ""
                commentsList.beginUpdates()
                commentsList.insertRows(at: [IndexPath(row: comments.count - 1, section: 0)], with: .automatic)
                commentsList.endUpdates()
                moveToLastComment()
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "註冊後方可留言及評分", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    // close keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    // move to last cell
    func moveToLastComment() {
        if commentsList.contentSize.height > commentsList.frame.height {
            // First figure out how many sections there are
            let lastSectionIndex = commentsList.numberOfSections - 1
            // Then grab the number of rows in the last section
            let lastRowIndex = commentsList.numberOfRows(inSection: lastSectionIndex) - 1
            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            // Make the last row visible
            commentsList.scrollToRow(at: pathToLastRow as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    func getRating() {
        ref = FIRDatabase.database().reference()
        ref?.child("rateing").child(storeID!).observeSingleEvent(of: .value, with: { (snapShot) in
            guard let dictScore = snapShot.value as? [String: String] else { return }

            if let scroe = dictScore["\(self.userID!)"] {
                self.rating.rating = Double(scroe)!
                self.rating.reloadInputViews()
            } else {
                self.rating.rating = 0.0
                self.rating.reloadInputViews()
            }
        })
    }
    private func didTouchCosmos(_ rating: Double) {
        print("touch star is : \(self.rating.rating)")
        let sendScore = ["\(userID!)": "\(self.rating.rating)"]
        ref = FIRDatabase.database().reference()
        ref?.child("rateing").child(storeID!).setValue(sendScore)
        FIRAnalytics.logEvent(withName: "Rating", parameters: nil)
        DispatchQueue.main.async {
            self.delegate?.detectIsClick()
        }
    }

    private func didFinishTouchingCosmos(_ rating: Double) {
        print("finish touch")
    }
}
