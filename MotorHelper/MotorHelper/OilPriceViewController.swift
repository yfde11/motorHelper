//
//  OilPriceViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 20/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class OilPriceViewController: UIViewController {

    let oilInfo = GetSOAPInfo()
    var product: [Petroleum] = []

    @IBOutlet weak var productName92: UILabel!
    @IBOutlet weak var productPrice92: UILabel!
    @IBOutlet weak var productName95: UILabel!
    @IBOutlet weak var productPrice95: UILabel!
    @IBOutlet weak var productName98: UILabel!
    @IBOutlet weak var productPrice98: UILabel!
    @IBOutlet weak var productNameSuper: UILabel!
    @IBOutlet weak var productPriceSuper: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let activityData = ActivityData()
        NVActivityIndicatorView.DEFAULT_TYPE = .pacman
        NVActivityIndicatorView.DEFAULT_COLOR = .yellow
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        oilInfo.getOilData(oiltype: "1") { (name, price) in
            self.productName92.text = name
            self.productPrice92.text = price
            self.oilInfo.getOilData(oiltype: "2") { (name, price) in
                self.productName95.text = name
                self.productPrice95.text = price
                self.oilInfo.getOilData(oiltype: "3") { (name, price) in
                    self.productName98.text = name
                    self.productPrice98.text = price
                    self.oilInfo.getOilData(oiltype: "4") { (name, price) in
                        self.productNameSuper.text = name
                        self.productPriceSuper.text = price
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
