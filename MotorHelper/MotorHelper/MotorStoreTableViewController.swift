//
//  MotorStoreTableViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 06/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MotorStoreTableViewController: UITableViewController {

    var stores: [Store] = []
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        getStoreData()
        setUp()
    }
    func getStoreData() {
        ref = FIRDatabase.database().reference()
        ref?.child("stores").observeSingleEvent(of: .value, with: { (snapshot) in
            for childSnap in snapshot.children.allObjects {
                guard
                    let snap = childSnap as? FIRDataSnapshot
                    else { return }
                print(snap)
                if let snapshotValue = snapshot.value as? NSDictionary,
                    let snapVal = snapshotValue[snap.key] as? [String:String] {
                    let storeName = snapVal["storeName"]
                    let phoneNumber = snapVal["phoneNumber"]
                    let address = snapVal["address"]
                    let store = Store(storeName: storeName!, storeAddress: address!, storePhoneNum: phoneNumber!)
                    self.stores.append(store)
                }
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreListInfoTableViewCell.identifier, for: indexPath) as? StoreListInfoTableViewCell
            else { return UITableViewCell()}
        cell.storeName.text = "\(stores[indexPath.row].storeName)"
        cell.address.text = "\(stores[indexPath.row].storeAddress)"
        cell.score.rating = 5
        return cell

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StoreListInfoTableViewCell.height
    }

    func setUp() {
        let storeDetailNib = UINib(nibName: StoreListInfoTableViewCell.identifier, bundle: nil)
        tableView.register(storeDetailNib, forCellReuseIdentifier: StoreListInfoTableViewCell.identifier)
    }
}
