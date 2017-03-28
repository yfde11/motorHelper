//
//  DateTableViewCell.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 24/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var dateName: UILabel!
    @IBOutlet weak var date: UITextField!

    static let identifier = "DateTableViewCell"
    static let height: CGFloat = 80.0
}
