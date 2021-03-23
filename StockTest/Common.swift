//
//  Common.swift
//  StockTest
//
//  Created by HahaSU on 2021/3/20.
//

import Foundation
import SystemConfiguration

extension String {
    var intValue: Int {
        get {
            return Int(self) ?? 0
        }
    }
    
    var floatValue: Float {
        get {
            return Float(self) ?? 0
        }
    }
    
    var doubleValueBut: Double? {
        get {
            return Double(self)
        }
    }
    
    var percentFloat: Float {
        get{
            return self.replacingOccurrences(of: "%", with: "").floatValue * 0.01
        }
    }
}

extension Int {
    var stringValue: String {
        get {
            return String(self)
        }
    }
}

extension Float {
    var stringValue: String {
        get {
            return String(format: "%.2f", self)
        }
    }
    
    var percentString: String {
        get {
            return String(format: "%.2f", self * 100).appending("%")
        }
    }
}

extension Date {
    func stringValue() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        return format.string(from: self)
    }
    
    func dateString() -> String {
        let format = DateFormatter()
        format.dateFormat = "YYYYMMdd"
        return format.string(from: self)
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
}

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
