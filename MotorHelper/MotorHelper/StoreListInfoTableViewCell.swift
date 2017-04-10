//
//  StoreListInfoTableViewCell.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 06/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import Cosmos

class StoreListInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var score: CosmosView!

    static let identifier = "StoreListInfoTableViewCell"
    static let height: CGFloat = 80.0
}