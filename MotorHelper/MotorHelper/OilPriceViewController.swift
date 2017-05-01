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
import FirebaseDatabase

class OilPriceViewController: UIViewController {

    let oilInfo = GetSOAPInfo()
    var ref: FIRDatabaseReference?
    var product: [Petroleum] = []

    @IBOutlet weak var productName92: UILabel!
    @IBOutlet weak var productPrice92: UILabel!
    @IBOutlet weak var productName95: UILabel!
    @IBOutlet weak var productPrice95: UILabel!
    @IBOutlet weak var productName98: UILabel!
    @IBOutlet weak var productPrice98: UILabel!
    @IBOutlet weak var productNameSuper: UILabel!
    @IBOutlet weak var productPriceSuper: UILabel!
    @IBOutlet weak var reloadBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date()
        reloadBtn.layer.cornerRadius = 15
        productName92.text = "無鉛汽油 92"
        productName95.text = "無鉛汽油 95"
        productName98.text = "無鉛汽油 98"
        productNameSuper.text = "柴油"
        if isInternetAvailable() {
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            getOilInfo(date: today)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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
    func getOilInfo(date: Date) {
        let monstr = getMonday(myDate: date)
        ref = FIRDatabase.database().reference()
        ref?.child("oilprice").child(monstr).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let oil92 = value?["gasoline92"] as? String ?? "no data"
            let oil95 = value?["gasoline95"] as? String ?? "no data"
            let oil98 = value?["gasoline98"] as? String ?? "no data"
            let oilSuper = value?["diesel"] as? String ?? "no data"
            self.productPrice92.text = "\(oil92) 元／公升"
            self.productPrice95.text = "\(oil95) 元／公升"
            self.productPrice98.text = "\(oil98) 元／公升"
            self.productPriceSuper.text = "\(oilSuper) 元／公升"
        })
    }
    func getMonday(myDate: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        var cal = Calendar.current
        cal.firstWeekday = 2
        let comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
        let beginningOfWeek = cal.date(from: comps)!
        let monStr = df.string(from: beginningOfWeek)
        return monStr
    }
    @IBAction func reload(_ sender: Any) {
        if productName92.text == "" {
            getOilInfo(date: Date())
        } else {
            let alertController = UIAlertController(title: "已更新", message: "目前為最新油價", preferredStyle: .alert)
            let jumpAction = UIAlertAction(title: "ＯＫ", style: .default)
            alertController.addAction(jumpAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
