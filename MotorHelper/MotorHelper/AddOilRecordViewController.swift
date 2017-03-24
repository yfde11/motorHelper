//
//  AddOilRecordViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 24/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class AddOilRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addConsumption: UITableView!
    // MARK: enum for cell type
    enum Component {
        case oilprice //油價
        case numOfOil //加油量
        case totalPrice //總價
        case totalKM //里程數
    }
    // MARK: Property
    var components: [Component] = [ Component.oilprice, Component.numOfOil, Component.totalPrice, Component.totalKM ] // index表示位置

    override func viewDidLoad() {
        super.viewDidLoad()

        addConsumption.delegate = self
        addConsumption.dataSource = self

        setUp()
    }

    // MARK: Set up
    func setUp() {
        let nib = UINib(nibName: TextTableViewCell.identifier, bundle: nil)
        addConsumption.register(nib, forCellReuseIdentifier: TextTableViewCell.identifier)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return components.count
    }
    //行數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = components[section]

        print("component:\(component) in section:\(section)")

        switch component {
        case .numOfOil, .oilprice, .totalKM, .totalPrice:
            return 1
        }
    }
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TextTableViewCell.height
    }
    //內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {
        case Component.oilprice:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "油價"
            cell.contentTextField.backgroundColor = UIColor.darkGray
            return cell

        case Component.numOfOil:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "油量"
            cell.contentTextField.backgroundColor = UIColor.blue
            return cell

        case Component.totalPrice:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "總價"
            cell.contentTextField.backgroundColor = UIColor.clear
            return cell

        case Component.totalKM:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "里程"
            cell.contentTextField.backgroundColor = UIColor.brown
            return cell

        }
    }
}
