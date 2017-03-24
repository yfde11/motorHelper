//
//  TextTableViewCell.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 24/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextName: UILabel!
    @IBOutlet weak var contentTextField: UITextField!

    static let identifier = "TextTableViewCell"
    static let height: CGFloat = 121.0

}
