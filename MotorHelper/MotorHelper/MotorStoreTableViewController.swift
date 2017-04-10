//
//  MotorStoreTableViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 06/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class MotorStoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreListInfoTableViewCell.identifier, for: indexPath) as? StoreListInfoTableViewCell
            else { return UITableViewCell()}
        cell.storeName.text = "test"
        cell.address.text = "address test"
        cell.score.rating = 5
        return cell

    }

    func setUp() {
        let storeDetailNib = UINib(nibName: StoreListInfoTableViewCell.identifier, bundle: nil)
        tableView.register(storeDetailNib, forCellReuseIdentifier: StoreListInfoTableViewCell.identifier)
    }
}
