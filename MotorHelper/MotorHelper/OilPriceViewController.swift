//
//  OilPriceViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 20/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import SystemConfiguration
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

        if isInternetAvailable() {
            let activityData = ActivityData()
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
        } else {
            let alertController = UIAlertController(title: "Error", message: "目前未連接網路", preferredStyle: .alert)
            let jumpAction = UIAlertAction(title: "ＯＫ", style: .default, handler: { ( _ ) -> Void in
                self.tabBarController?.selectedIndex = 0
                self.productName92.text = ""
                self.productPrice92.text = ""
                self.productName95.text = ""
                self.productPrice95.text = ""
                self.productName98.text = "請檢查您的網路是否有連線"
                self.productPrice98.text = ""
                self.productNameSuper.text = ""
                self.productPriceSuper.text = ""
                
            })
            alertController.addAction(jumpAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
