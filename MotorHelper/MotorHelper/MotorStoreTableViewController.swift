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
//import ReverseExtension

class MotorStoreTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    var stores: [Store] = []
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    var scores = [String: Double]()

    let searchController = UISearchController(searchResultsController: nil)
    var searchTableView: UITableView!
    var filteredStores = [Store]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var shouldShowSearchResults = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getStoreData()
        setUp()
        tableView.delegate = self
        tableView.dataSource = self

        searchBarSetup()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredStores.count
        } else {
            return stores.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchController.isActive {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: StoreListInfoTableViewCell.identifier, for: indexPath) as? StoreListInfoTableViewCell
                else { return UITableViewCell()}
            cell.storeName.text = "\(filteredStores[indexPath.row].storeName)"
            cell.address.text = "\(filteredStores[indexPath.row].storeAddress)"
            cell.phone.text = "\(filteredStores[indexPath.row].storePhoneNum)"
            let id  = filteredStores[indexPath.row].storeID
            cell.score.settings.fillMode = .precise
            if scores[id] == nil {
                cell.score.rating = 0
            } else {
                cell.score.rating = scores[id]!
            }
            cell.score.settings.updateOnTouch = false
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: StoreListInfoTableViewCell.identifier, for: indexPath) as? StoreListInfoTableViewCell
                else { return UITableViewCell()}
            cell.storeName.text = "\(stores[indexPath.row].storeName)"
            cell.address.text = "\(stores[indexPath.row].storeAddress)"
            cell.phone.text = "\(stores[indexPath.row].storePhoneNum)"
            let id  = stores[indexPath.row].storeID
            cell.score.settings.fillMode = .precise
            if scores[id] == nil {
                cell.score.rating = 0
            } else {
                cell.score.rating = scores[id]!
            }
            cell.score.settings.updateOnTouch = false
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StoreListInfoTableViewCell.height
    }

    func setUp() {
        let storeDetailNib = UINib(nibName: StoreListInfoTableViewCell.identifier, bundle: nil)
        tableView.register(storeDetailNib, forCellReuseIdentifier: StoreListInfoTableViewCell.identifier)
    }

    func getStoreData() {
        ref = FIRDatabase.database().reference()
        ref?.child("stores").observeSingleEvent(of: .value, with: { (snapshot) in
            for childSnap in snapshot.children.allObjects {
                guard
                    let snap = childSnap as? FIRDataSnapshot
                    else { return }
                if let snapshotValue = snapshot.value as? NSDictionary,
                    let snapVal = snapshotValue[snap.key] as? [String:String] {
                    let storeName = snapVal["storeName"]
                    let phoneNumber = snapVal["phoneNumber"]
                    let address = snapVal["address"]
                    let storeID = snap.key
                    let store = Store(storeName: storeName!, storeAddress: address!, storePhoneNum: phoneNumber!, storeID: storeID)
                    self.stores.append(store)
                }
            }
            self.tableView.reloadData()
        })
        ref?.child("rateing").observeSingleEvent(of: .value, with: { (snapshot) in
            for childSnap in snapshot.children.allObjects {
                guard let snap = childSnap as? FIRDataSnapshot else { return }
                if let snapshotValue = snapshot.value as? NSDictionary,
                    let snapVal = snapshotValue[snap.key] as? [String:String] {
                    var sum = 0.0
                    var count = 0.0
                    for scoreValue in snapVal.values {
                        sum += Double(scoreValue)!
                        count += 1.0
                    }
                    self.scores["\(snap.key)"] = sum/count
                }
            }
            self.tableView.reloadData()
        })
    }

    @IBAction func addStore(_ sender: Any) {
        searchController.dismiss(animated: true, completion: nil)
        guard
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddStoreViewController") as? AddStoreViewController
            else { return }
        vc.delegate = self
        self.show(vc, sender: nil)
    }
}

extension MotorStoreTableViewController {
    //選到那個欄位
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            print("\(stores[indexPath.row].storeID)")
            guard
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController
                else { return }
            vc.storeID = filteredStores[indexPath.row].storeID
            vc.sendName = filteredStores[indexPath.row].storeName
            vc.sendPhone = filteredStores[indexPath.row].storePhoneNum
            vc.sendAddress = filteredStores[indexPath.row].storeAddress
            vc.delegate = self
            self.show(vc, sender: nil)
            searchController.dismiss(animated: true, completion: nil)
        } else {
            print("\(stores[indexPath.row].storeID)")
            guard
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController
                else { return }
            vc.storeID = stores[indexPath.row].storeID
            vc.sendName = stores[indexPath.row].storeName
            vc.sendPhone = stores[indexPath.row].storePhoneNum
            vc.sendAddress = stores[indexPath.row].storeAddress
            vc.delegate = self
            self.show(vc, sender: nil)
        }
    }
}

extension MotorStoreTableViewController {
    func updateSearchResults(for searchController: UISearchController) {
        // 取得搜尋文字
        guard let searchText = searchController.searchBar.text else {
            return
        }
        filteredStores = stores.filter({ (store) -> Bool in
            return store.storeName.contains(searchText)
        })
    }
    func searchBarSetup() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }
    func dismissKeyboard() {
        view.endEditing(true)
        searchController.dismiss(animated: true, completion: nil)
    }
}

extension MotorStoreTableViewController: buttonIsClick {
    func detectIsClick() {
        self.stores.removeAll()
        self.scores.removeAll()
        self.getStoreData()
        print("Click")
    }
}
