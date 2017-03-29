//
//  ConsumptionRecord.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 28/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

class ComsumptionRecord {
    var date: String
    var oilType: String
    var oilPrice: String
    var numOfOil: String
    var totalPrice: String
    var totalKM: String

    init(date: String, oilType: String, oilPrice: String, numOfOil: String, totalPrice: String, totalKM: String) {
        self.date = date
        self.oilType = oilType
        self.oilPrice = oilPrice
        self.numOfOil = numOfOil
        self.totalPrice = totalPrice
        self.totalKM = totalKM
    }
}
