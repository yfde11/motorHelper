//
//  OilConsumptionManager.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 29/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol OilConsumptionManagerDelegate: class {
    func manager(_ manager: OilConsumptionManager, didGet records: [ConsumptionRecord])
    func manager(_ manager: OilConsumptionManager, didFailWith error: Error)
}

class OilConsumptionManager {
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    weak var delegate: OilConsumptionManagerDelegate?
    static let shared = OilConsumptionManager()

    var records: [ConsumptionRecord] = []

    func getRecords() {
        ref = FIRDatabase.database().reference()
        ref?.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.records.removeAll()
            print("Snap: \(snapshot)")
            print("SnapChild: \(snapshot.children)")
            print("Snap: \(snapshot.children.allObjects)")
            for childSnap in snapshot.children.allObjects {
                guard
                    let snap = childSnap as? FIRDataSnapshot
                    else { return }
                print(snap)
                if let snapshotValue = snapshot.value as? NSDictionary,
                    let snapVal = snapshotValue[snap.key] as? [String:String] {
                        let date = snapVal["date"]
                        let oilType = snapVal["oilType"]
                        let numOfOil = snapVal["numOfOil"]
                        let totalKM = snapVal["totalKM"]
                        let totalPrice = snapVal["totalPrice"]
                        let oilPrice = snapVal["oilPrice"]
                        let record = ConsumptionRecord(date: date!, oilType: oilType!, oilPrice: oilPrice!, numOfOil: numOfOil!, totalPrice: totalPrice!, totalKM: totalKM!)
                    self.records.append(record)
                    self.delegate?.manager(self, didGet: self.records)
                }
            }
        })
    }
}
