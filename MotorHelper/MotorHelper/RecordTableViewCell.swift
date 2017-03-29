//
//  RecordTableViewCell.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 29/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var oilType: UILabel!
    @IBOutlet weak var numOfOil: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var dateOfAddRecord: UILabel!
    @IBOutlet weak var totalKM: UILabel!

    static let identifier = "RecordTableViewCell"
    static let height: CGFloat = 80.0
}
