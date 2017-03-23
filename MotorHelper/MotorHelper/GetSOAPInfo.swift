//
//  getSOAPInfo.swift
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

class GetSOAPInfo {
    func getOilData(oiltype: String, completion: @escaping ((_ name: String, _ price: String) -> Void)) {
        
            var product: [Petroleum] = []
            var prod: Petroleum?
            let soapRequest = AEXMLDocument()
            let envelopeAttributes = ["xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
                                      "xmlns:xsd": "http://www.w3.org/2001/XMLSchema",
                                      "xmlns:soap12": "http://www.w3.org/2003/05/soap-envelope"]
            let envelope = soapRequest.addChild(name: "soap12:Envelope", attributes: envelopeAttributes)
            let body = envelope.addChild(name: "soap12:Body")
            let att = ["xmlns": "http://tmtd.cpc.com.tw/"]
            let prodid = body.addChild(name: "getCPCMainProdListPrice_Historical", attributes: att)
            //value決定跳出來的油品
            prodid.addChild(name: "prodid", value: "\(oiltype)")
            let url = URL(string: "https://vipmember.tmtd.cpc.com.tw/OpenData/ListPriceWebService.asmx")

            var mutableR = URLRequest(url: url! as URL)
            mutableR.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mutableR.httpMethod = "POST"
            mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)

            Alamofire.request(mutableR).responseString { response in
                if let xmlString = response.result.value {
                    let xml = SWXMLHash.parse(xmlString)
                    let body =  xml["soap:Envelope"]["soap:Body"]
                    if let oilElement = body["getCPCMainProdListPrice_HistoricalResponse"]["getCPCMainProdListPrice_HistoricalResult"]["diffgr:diffgram"]["NewDataSet"].element {
                        let xmlInner = SWXMLHash.parse(oilElement.description)
                        let productName = xmlInner["NewDataSet"]["tbTable"][oilElement.children.count-1]["產品名"].element!.text!
                        let productPrice = xmlInner["NewDataSet"]["tbTable"][oilElement.children.count-1]["參考牌價"].element!.text!
                        prod = Petroleum(oilName: productName, oilPrice: productPrice)
                        product.append(prod!)
                        completion(productName, productPrice)
                    }
//                    completion(product)
                } else {
                    print("error fetching XML")
                }
//                completion(product)
            }
//            completion(product)
        }
    
}
