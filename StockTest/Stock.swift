//
//  Stock.swift
//  StockTest
//
//  Created by HahaSU on 2021/3/20.
//

import Foundation

struct Stock {
    var code = ""
    var name = ""
    var closingPrise = ""
    var openingPrise = ""
    var prise = ""
    var bidPrise = ""
    var offerPrise = ""
    var volumn = ""
    var totalVolumn = ""
    var bidVolumn = ""
    var offerVolumn = ""
    var topPrise = ""
    var bottomPrise = ""
    var amplitude = ""
    var isRed = true
    var spread = ""
    
    init() {
        
    }
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
        
        self.closingPrise = Float.random(in: 0 ... 100).stringValue
        self.openingPrise = Float.random(in: 0 ... 100).stringValue
        self.prise = Float.random(in: 0 ... 100).stringValue
        self.bidPrise = Float.random(in: 0 ... 100).stringValue
        self.offerPrise = Float.random(in: 0 ... 100).stringValue
        self.volumn = Int.random(in: 1 ... 100).stringValue
        self.totalVolumn = Int.random(in: 1 ... 30000).stringValue
        self.bidVolumn = Int.random(in: 1 ... 5000).stringValue
        self.offerVolumn = Int.random(in: 1 ... 5000).stringValue
        self.topPrise = Float.random(in: 0 ... 100).stringValue
        self.bottomPrise = Float.random(in: 0 ... 100).stringValue
        self.amplitude = (closingPrise.intValue - openingPrise.intValue).stringValue
        self.isRed = Bool.random()
        self.spread = Float.random(in: 0 ... 1000).stringValue
    }
}
