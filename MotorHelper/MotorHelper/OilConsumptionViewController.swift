//
//  OilConsumptionViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 24/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class OilConsumptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OilConsumptionManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var ref: FIRDatabaseReference?
    var records: [ConsumptionRecord] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        OilConsumptionManager.shared.delegate = self
        OilConsumptionManager.shared.getRecords()

        setUp()
    }
    func setUp() {
        let detailNib = UINib(nibName: RecordTableViewCell.identifier, bundle: nil)
        tableView.register(detailNib, forCellReuseIdentifier: RecordTableViewCell.identifier)
        self.tableView.allowsSelection = false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as? RecordTableViewCell
            else { return UITableViewCell() }
        cell.dateOfAddRecord.text = "\(records[indexPath.row].date)"
        cell.numOfOil.text = "\(records[indexPath.row].numOfOil) 公升"
        cell.oilType.text = "\(records[indexPath.row].oilType)"
        cell.totalKM.text = "\(records[indexPath.row].totalKM) 公里"
        cell.totalPrice.text = "\(records[indexPath.row].totalPrice)元"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecordTableViewCell.height
    }

    func manager(_ manager: OilConsumptionManager, didFailWith error: Error) {
        print("error")
    }
    func manager(_ manager: OilConsumptionManager, didGet records: [ConsumptionRecord]) {
//        self.records = records.reversed()
        self.records = records
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.moveToLastRecord()
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        }
    }

    @IBAction func addRecord(_ sender: Any) {
        guard
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddOilRecordViewController") as? AddOilRecordViewController
            else { return }
        vc.delegate = self
        self.show(vc, sender: nil)
    }
    // move to last cell
    func moveToLastRecord() {
        if tableView.contentSize.height > tableView.frame.height {
            // First figure out how many sections there are
            let lastSectionIndex = tableView.numberOfSections - 1
            // Then grab the number of rows in the last section
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            // Make the last row visible
            tableView.scrollToRow(at: pathToLastRow as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
}
extension OilConsumptionViewController: submitIsClick {
    func detectSubmit() {
        OilConsumptionManager.shared.getRecords()
        self.tableView.reloadData()
    }
}
