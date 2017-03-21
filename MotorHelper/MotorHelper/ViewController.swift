//
//  ViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 20/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import StringExtensionHTML
import AEXML

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getOilData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getOilData() {
        var result = ""
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = ["xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
                                  "xmlns:xsd": "http://www.w3.org/2001/XMLSchema",
                                  "xmlns:soap12": "http://www.w3.org/2003/05/soap-envelope"]
        let envelope = soapRequest.addChild(name: "soap12:Envelope", attributes: envelopeAttributes)
        let body = envelope.addChild(name: "soap12:Body")
        let att = ["xmlns": "http://tmtd.cpc.com.tw/"]
        let prodid = body.addChild(name: "getCPCMainProdListPrice_Historical", attributes: att)
        prodid.addChild(name: "prodid", value: "1")

//        print(soapRequest.xml)
//        let theURL = NSURL(string: "vipmember.tmtd.cpc.com.tw/OpenData/ListPriceWebService.asmx")
        let url = URL(string: "https://vipmember.tmtd.cpc.com.tw/OpenData/ListPriceWebService.asmx")

        var mutableR = URLRequest(url: url! as URL)
        mutableR.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
//        print(mutableR)
        //swiftlint: disable force_cast
        Alamofire.request(mutableR)
            .responseString { response in
//                print(response)
                if let xmlString = response.result.value {
//                    print(xmlString)
                    let xml = SWXMLHash.parse(xmlString)
//                    print(xml.element)
                    let body =  xml["soap:Envelope"]["soap:Body"]
                    if let oilElement = body["getCPCMainProdListPrice_HistoricalResponse"]["getCPCMainProdListPrice_HistoricalResult"]["diffgr:diffgram"]["NewDataSet"].element {
//                        print("allElement:\(oilElement)")
//                        print(oilElement.children.count)
//                        print(oilElement.children)
//                        print("=======================================")
//                        print(oilElement.description)
                        let xmlInner = SWXMLHash.parse(oilElement.description)
//                        print(xmlInner)
                        for element in xmlInner["NewDataSet"]["tbTable"].all {
//                            print("element")
                            if let nameElement = element["參考牌價"].element {
                                print("參考牌價:\(nameElement)")
                            }
                        }
                        print("lastone:\(xmlInner["NewDataSet"]["tbTable"][oilElement.children.count-1]["參考牌價"].element!.text!)")

//                        let getCountriesResult = countriesElement.text!
//                        let xmlInner = SWXMLHash.parse(oilElement)
//                        for element in xmlInner["tbTable"].all {
//                            print(element)
//                            if let nameElement = element["產品名"].element {
//                                print(nameElement)
////                                var countryStruct = Country()
////                                countryStruct.name = nameElement.text!
////                                result.append(countryStruct)
//                            }
//                        }
                    }
//                    completion(result: result)
                } else {
                    print("error fetching XML")
                }
        }
    }
}
