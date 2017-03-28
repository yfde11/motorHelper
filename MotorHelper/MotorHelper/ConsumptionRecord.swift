//
//  ConsumptionRecord.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 28/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

class ComsumptionRecodr {
    let date: String
    let oilType: String
    let oilPrice: String
    let numOfOil: String
    let totalPrice: String
    let totalKM: String

    init(date: String, oilType: String, oilPrice: String, numOfOil: String, totalPrice: String, totalKM: String) {
        self.date = date
        self.oilType = oilType
        self.oilPrice = oilPrice
        self.numOfOil = numOfOil
        self.totalPrice = totalPrice
        self.totalKM = totalKM
    }
}
