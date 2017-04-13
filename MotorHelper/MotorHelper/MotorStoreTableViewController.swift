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

    let searchController = UISearchController(searchResultsController: nil)
    var searchTableView: UITableView!
    var filteredStores = [Store]() {
        didSet {
            self.tableView.reloadData()
        }
    }
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
        // 將更新搜尋結果的對象設為 self
        searchController.searchResultsUpdater = self

        // 搜尋時是否隱藏 NavigationBar
        // 這個範例沒有使用 NavigationBar 所以設置什麼沒有影響
        searchController.hidesNavigationBarDuringPresentation = false

        // 搜尋時是否使用燈箱效果 (會將畫面變暗以集中搜尋焦點)
        searchController.dimsBackgroundDuringPresentation = false

        // 搜尋框的樣式
        searchController.searchBar.searchBarStyle = .prominent
        // 設置搜尋框的尺寸為自適應
        // 因為會擺在 tableView 的 header
        // 所以尺寸會與 tableView 的 header 一樣
        searchController.searchBar.sizeToFit()

        // 將搜尋框擺在 tableView 的 header
        self.tableView.tableHeaderView = searchController.searchBar
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
            cell.score.rating = 5
            cell.score.settings.updateOnTouch = false
            return cell
        } else {
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
}
