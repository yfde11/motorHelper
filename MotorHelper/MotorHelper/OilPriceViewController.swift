//
//  OilPriceViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 20/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit

class OilPriceViewController: UIViewController {

    let oilInfo = GetSOAPInfo()
    var product: [Petroleum] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...4 {
            oilInfo.getOilData(oilType: "\(i)") { (productName, productPrice) in
                print("\(productName), \(productPrice)元／公升")
                let prod = Petroleum(oilName: productName, oilPrice: productPrice)
                self.product.append(prod)
            }
        }
        print(product.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
