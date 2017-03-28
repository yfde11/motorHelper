//
//  AddOilRecordViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 24/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift

class AddOilRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addConsumption: UITableView!
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()

    // MARK: enum for cell type
    enum Component {
        case date //日期
        case oilprice //油價
        case numOfOil //加油量
        case totalPrice //總價
        case totalKM //里程數
        case addBtn //新增紀錄
        case oilType //油品種類
    }
    // MARK: Property
    var components: [Component] = [ Component.date, Component.oilType, Component.oilprice, Component.numOfOil, Component.totalPrice, Component.totalKM, Component.addBtn ] // index表示位置

    override func viewDidLoad() {
        super.viewDidLoad()

        addConsumption.delegate = self
        addConsumption.dataSource = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        setUp()
    }

    // MARK: Set up
    func setUp() {
        let textNib = UINib(nibName: TextTableViewCell.identifier, bundle: nil)
        addConsumption.register(textNib, forCellReuseIdentifier: TextTableViewCell.identifier)

        let btnNib = UINib(nibName: AddRecordBtnTableViewCell.identifier, bundle: nil)
        addConsumption.register(btnNib, forCellReuseIdentifier: AddRecordBtnTableViewCell.identifier)

        let dateNib = UINib(nibName: DateTableViewCell.identifier, bundle: nil)
        addConsumption.register(dateNib, forCellReuseIdentifier: DateTableViewCell.identifier)

        let oilTypeNib = UINib(nibName: SegmentTableViewCell.identifier, bundle: nil)
        addConsumption.register(oilTypeNib, forCellReuseIdentifier: SegmentTableViewCell.identifier)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return components.count
    }
    //行數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = components[section]

        print("component:\(component) in section:\(section)")

        switch component {
        case .numOfOil, .oilprice, .totalKM, .totalPrice, .addBtn, .date, .oilType:
            return 1
        }
    }
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TextTableViewCell.height
    }
    //內容
    //swiftlint:disable cyclomatic_complexity
    //swiftlint:disable function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {
        case Component.oilprice:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "油價"
            //輸入框內顯示清除的符號－－＞編輯時顯示
            cell.contentTextField.clearButtonMode = .whileEditing
            cell.contentTextField.keyboardType = .numbersAndPunctuation
            cell.contentTextField.textColor = UIColor.white
            cell.contentTextField.backgroundColor = UIColor.darkGray
            cell.contentTextField.returnKeyType = .done
            cell.contentTextField.delegate = self
            cell.index = TextFieldType.oilPrice
            return cell

        case Component.numOfOil:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "油量"
            cell.contentTextField.backgroundColor = UIColor.blue
            cell.contentTextField.clearButtonMode = .whileEditing
            cell.contentTextField.keyboardType = .numbersAndPunctuation
            cell.contentTextField.textColor = UIColor.white
            cell.contentTextField.returnKeyType = .done
            cell.contentTextField.delegate = self
            cell.index = TextFieldType.numOfOil
            return cell

        case Component.totalPrice:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "總價"
            cell.contentTextField.backgroundColor = UIColor.black
            cell.contentTextField.clearButtonMode = .whileEditing
            cell.contentTextField.keyboardType = .numbersAndPunctuation
            cell.contentTextField.textColor = UIColor.white
            cell.contentTextField.returnKeyType = .done
            cell.contentTextField.delegate = self
            cell.index = TextFieldType.totalPrice
            return cell

        case Component.totalKM:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "里程"
            cell.contentTextField.backgroundColor = UIColor.brown
            cell.contentTextField.clearButtonMode = .whileEditing
            cell.contentTextField.keyboardType = .numbersAndPunctuation
            cell.contentTextField.textColor = UIColor.white
            cell.contentTextField.returnKeyType = .done
            cell.contentTextField.delegate = self
            cell.index = TextFieldType.totalKM
            return cell

        case Component.addBtn:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddRecordBtnTableViewCell.identifier, for: indexPath) as? AddRecordBtnTableViewCell else { return UITableViewCell() }

            cell.addRecord.setTitle("新增紀錄", for: .normal)
            cell.addRecord.addTarget(self, action: #selector(sendData), for: .touchUpInside)

            return cell

        case Component.date:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }

            cell.contentTextName.text = "日期"
            //datepicker
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(AddOilRecordViewController.didSelectedDate), for: .valueChanged)
            //toolbar
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            //bar button item
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissKeyboard))
            
            toolbar.setItems([doneButton], animated: false)
            cell.contentTextField.inputAccessoryView = toolbar
            cell.contentTextField.inputView = datePicker
            cell.index = TextFieldType.date
            return cell

        case Component.oilType:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SegmentTableViewCell.identifier, for: indexPath) as? SegmentTableViewCell else { return UITableViewCell() }
            return cell

        }
    }
    func sendData() {
        print("send Data success")
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func didSelectedDate(_ sender: Any) {

        if
            let picker = sender as? UIDatePicker,
            picker === datePicker,
            let dateSection = components.index(of: Component.date) {

                let indexPath = IndexPath(row: 0, section: dateSection)
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .none

                let cell = addConsumption.cellForRow(at: indexPath) as? TextTableViewCell

                cell?.contentTextField.text = dateFormatter.string(from: picker.date)

        }
    }

}

extension AddOilRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? TextTableViewCell else {return }
        print("\(cell.index)")
        print("\(cell.contentTextName.text!)")
        print("\(cell.contentTextField.text!)")
    }
}
