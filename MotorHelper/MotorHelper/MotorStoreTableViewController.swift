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

class MotorStoreTableViewController: UITableViewController, UISearchBarDelegate {

    var stores: [Store] = []
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid

    let searchController = UISearchController(searchResultsController: nil)
    var filteredStores = [Store]()
    var shouldShowSearchResults = false

    override func viewDidLoad() {
        super.viewDidLoad()
        getStoreData()
        setUp()
        tableView.delegate = self
        tableView.dataSource = self

        searchBarSetup()
    }
    func searchBarSetup() {
        let searchBar = UISearchBar(frame: CGRect(x:0, y:0, width:(UIScreen.main.bounds.width), height:70))
        searchBar.showsScopeBar = true
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredStores = stores
            self.tableView.reloadData()
        } else {
            filterTableView(text: searchText)
        }
    }
    func filterTableView( text: String ) {
        //fix of not searching when backspacing
        filteredStores = stores.filter({ (searchedStore) -> Bool in
//            return mod.imageBy.lowercased().contains(text.lowercased())
            return searchedStore.storeName.contains(text)
        })
        self.tableView.reloadData()
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
        cell.phone.text = "\(stores[indexPath.row].storePhoneNum)"
        cell.score.rating = 5
        cell.score.settings.updateOnTouch = false
        return cell

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StoreListInfoTableViewCell.height
    }
    //選到那個欄位
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(stores[indexPath.row].storeID)")
        guard
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController
        else { return }
        vc.storeID = stores[indexPath.row].storeID
        vc.sendName = stores[indexPath.row].storeName
        vc.sendPhone = stores[indexPath.row].storePhoneNum
        vc.sendAddress = stores[indexPath.row].storeAddress
        self.show(vc, sender: nil)
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
    }
}
