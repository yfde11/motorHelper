//
//  TableViewCell.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 11/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var userComment: UILabel!
    static let identifier = "CommentTableViewCell"
    static let height: CGFloat = 50.0
}
