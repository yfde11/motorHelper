//
//  Store.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 10/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

class Store {
    let storeName: String
    let storeAddress: String
    let storePhoneNum: String
    let storeID: String
    var storeRate: String?
    var scoreTimes: String?

    init(storeName: String, storeAddress: String, storePhoneNum: String, storeRate: String, scoreTimes: String, storeID: String) {
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.storePhoneNum = storePhoneNum
        self.storeRate = storeRate
        self.scoreTimes = scoreTimes
        self.storeID = storeID
    }

    init(storeName: String, storeAddress: String, storePhoneNum: String, storeID: String) {
        self.storeID = storeID
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.storePhoneNum = storePhoneNum
    }
}

class Comment {
    let userID: String
    let commentContent: String

    init(userID: String, commentContent: String) {
        self.userID = userID
        self.commentContent = commentContent
    }
}
