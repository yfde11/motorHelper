//
//  AddOilRecordViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 24/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddOilRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addConsumption: UITableView!
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var record = ConsumptionRecord(date: "", oilType: "92", oilPrice: "0", numOfOil: "0", totalPrice: "0", totalKM: "0")
    var ref: FIRDatabaseReference?

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
    let components: [Component] = [ Component.date, Component.oilType, Component.oilprice, Component.numOfOil, Component.totalPrice, Component.totalKM, Component.addBtn ] // index表示位置

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
            cell.contentTextField.returnKeyType = .google
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
            record.date = DateFormatter.localizedString(from: datePicker.date, dateStyle: .long, timeStyle: .none)
            cell.contentTextField.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .long, timeStyle: .none)
            cell.index = TextFieldType.date
            cell.contentTextField.textAlignment = .center
            cell.contentTextField.delegate = self
            return cell

        case Component.oilType:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SegmentTableViewCell.identifier, for: indexPath) as? SegmentTableViewCell else { return UITableViewCell() }
            cell.oilTypeSegment.addTarget(self, action: #selector(AddOilRecordViewController.onChange), for: .valueChanged)
            return cell

        }
    }
    // close keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    //get date
    func didSelectedDate(_ sender: Any) {

        if
            let picker = sender as? UIDatePicker,
            picker === datePicker,
            let dateSection = components.index(of: Component.date) {

                let indexPath = IndexPath(row: 0, section: dateSection)
                dateFormatter.dateStyle = .long //formatter樣式
                dateFormatter.timeStyle = .none //不要時間

                let cell = addConsumption.cellForRow(at: indexPath) as? TextTableViewCell

                cell?.contentTextField.text = dateFormatter.string(from: picker.date)

        }
    }
    //segment
    func onChange(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) as Any)
    }

}

extension AddOilRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? TextTableViewCell else {return }
        switch cell.index! {
            case .oilPrice:
                record.oilPrice = cell.contentTextField.text!
            case .numOfOil:
                record.numOfOil = cell.contentTextField.text!
            case .totalPrice:
                record.totalPrice = cell.contentTextField.text!
            case .totalKM:
                record.totalKM = cell.contentTextField.text!
            case .date:
                record.date = cell.contentTextField.text!
        }
    }
    //限制只能輸入數字與小數點
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
// MARK: submit button
extension AddOilRecordViewController {
    func sendData() {
        guard
            let oilTypeSection = components.index(of: .oilType)
            else { return }
        let indexPath = IndexPath(row: 0, section: oilTypeSection)
        guard
            let cell = addConsumption.cellForRow(at: indexPath) as? SegmentTableViewCell
            else { return }
        //判斷選擇的油品
        if cell.oilTypeSegment.selectedSegmentIndex == 3 {
            record.oilType = "超級柴油"
        } else {
            record.oilType = "\(cell.oilTypeSegment.titleForSegment(at: (cell.oilTypeSegment.selectedSegmentIndex))!)無鉛汽油"
        }
        let sendData = ["date": "\(record.date)",
                        "oilType": "\(record.oilType)",
                        "oilPrice": "\(record.oilPrice)",
                        "numOfOil": "\(record.numOfOil)",
                        "totalPrice": "\(record.totalPrice)",
                        "totalKM": "\(record.totalKM)"]
        ref = FIRDatabase.database().reference()
        ref?.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(sendData)

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "oilConsumeNavigationController")
        self.present(vc!, animated: true, completion: nil)
    }
}
