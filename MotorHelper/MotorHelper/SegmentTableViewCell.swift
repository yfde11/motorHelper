//
//  SegmentTableViewCell.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 27/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class SegmentTableViewCell: UITableViewCell {

    @IBOutlet weak var oilType: UILabel!
    @IBOutlet weak var oilTypeSegment: UISegmentedControl!

    static let identifier = "SegmentTableViewCell"
    static let height: CGFloat = 80.0
}
