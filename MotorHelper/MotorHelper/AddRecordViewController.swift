//
//  AddRecordViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 19/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var oilType: UISegmentedControl!
    @IBOutlet weak var oilPrice: UILabel!
    @IBOutlet weak var oilCountTextfield: UITextField!
    @IBOutlet weak var oilTotalPrice: UITextField!
    @IBOutlet weak var totalKM: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOilType()
        setUpTextfield()
        setUpOilPrice()
    }
    //setUp textfield
    func setUpTextfield() {
        //oilCount
        oilCountTextfield.placeholder = "請輸入加油量"
        oilCountTextfield.clearButtonMode = .whileEditing
        oilCountTextfield.keyboardType = .numbersAndPunctuation
        oilCountTextfield.delegate = self
        //oilTotalPrice
        oilTotalPrice.placeholder = "\(Double(oilCountTextfield.text!) ?? 0)"
        oilTotalPrice.clearButtonMode = .whileEditing
        oilTotalPrice.keyboardType = .numbersAndPunctuation
        oilTotalPrice.delegate = self
        //totalKM
        totalKM.placeholder = "請輸入目前里程數"
        totalKM.clearButtonMode = .whileEditing
        totalKM.keyboardType = .numbersAndPunctuation
        totalKM.delegate = self
    }
    func setUpOilType() {
        oilType.selectedSegmentIndex = 0

        oilType.addTarget(self, action: #selector(AddRecordViewController.oilTypeChange), for: .valueChanged)
    }
    func setUpOilPrice() {
        GetSOAPInfo().getOilData(oiltype: "1", completion: { ( _, price) in
            self.oilPrice.text = price
        })
    }
    func oilTypeChange(_ sender: UISegmentedControl) {
        switch oilType.selectedSegmentIndex {
        case 0:
            GetSOAPInfo().getOilData(oiltype: "1", completion: { ( _, price) in
                self.oilPrice.text = price
            })
        case 1:
            GetSOAPInfo().getOilData(oiltype: "2", completion: { ( _, price) in
                self.oilPrice.text = price
            })
        case 2:
            GetSOAPInfo().getOilData(oiltype: "3", completion: { ( _, price) in
                self.oilPrice.text = price
            })
        case 3:
            GetSOAPInfo().getOilData(oiltype: "4", completion: { ( _, price) in
                self.oilPrice.text = price
            })
        default:
            oilPrice.text = "92"
        }
    }
    @IBAction func submitBtn(_ sender: Any) {
    }

    func closeKeyboard() {
        view.endEditing(true)
    }
}
extension AddRecordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch oilType.selectedSegmentIndex {
        case 0:
            oilTotalPrice.text = "hello"
        case 1:
            oilTotalPrice.text = "world"
        case 2:
            oilTotalPrice.text = "GGGGG"
        case 3:
            oilTotalPrice.text = "QQQQQ"
        default:
            print("enter default")
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
//select date
extension AddRecordViewController {
    func didSelectedDate(_ sender: Any) {
//        if
//            let picker = sender as? UIDatePicker,
//            picker === datePicker,
//            let dateSection = components.index(of: Component.date) {
//            
//            let indexPath = IndexPath(row: 0, section: dateSection)
//            dateFormatter.dateStyle = .long //formatter樣式
//            dateFormatter.timeStyle = .none //不要時間
//            
//            let cell = addConsumption.cellForRow(at: indexPath) as? TextTableViewCell
//            
//            cell?.contentTextField.text = dateFormatter.string(from: picker.date)
//            
//        }
    }
}
