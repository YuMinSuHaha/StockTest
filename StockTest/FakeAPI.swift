//
//  FakeAPI.swift
//  StockTest
//
//  Created by HahaSU on 2021/3/20.
//

import Foundation

class FakeAPI {
    
    static let shared = FakeAPI()
    
    var selectedCode: [String] = []
    
    var allStock: [[String]] = []
    
    let backupALL: [[String]] =
        [
            ["00677U", "期富邦VIX"],
            ["2609"   , "陽明"],
            ["2603"   , "長榮"],
            ["3481"   , "群創"],
            ["00715L" ,  "期街口布蘭特正2"],
            ["2303"   , "聯電"],
            ["2610"   , "華航"],
            ["2353"   , "宏碁"],
            ["2317"   , "鴻海"],
            ["3576"   , "聯合再生"],
            ["2883"   , "開發金"],
            ["00632R" , "元大台灣50反1"],
            ["2409"   , "友達"],
            ["2888"   , "新光金"],
            ["2344"   , "華邦電"],
            ["2457"   , "飛宏"],
            ["2890"   , "永豐金"],
            ["00637L" , "元大滬深300正2"],
            ["2489"   , "瑞軒"],
            ["2337"   , "旺宏"],
            ["2356"   , "英業達"],
            ["2330"   , "台積電"],
            ["2882"   , "國泰金"],
            ["00642U"   , "期元大S&P石油"],
            ["2891"   , "中信金"],
            ["6116"   , "彩晶"],
            ["3704"   , "合勤控"],
            ["2618"   , "長榮航"],
            ["2601"   , "益航"],
            ["3231"   , "緯創"],
            ["3094"   , "聯傑"],
            ["00881"   , "國泰台灣5G+"],
            ["2881"   , "富邦金"],
            ["2641"   , "正德"],
            ["8054"   , "安國"],
            ["2324"   , "仁寶"],
            ["4961"   , "天鈺"],
            ["6443"   , "元晶"],
            ["2884"   , "玉山金"],
            ["2338"   , "光罩"],
            ["2886"   , "兆豐金"],
            ["2002"   , "中鋼"],
            ["2363"   , "矽統"],
            ["2014"   , "中鴻"],
            ["2892"   , "第一金"],
            ["2331"   , "精英"],
            ["5608"   , "四維航"],
            ["2605"   , "新興"],
            ["3037"   , "欣興"],
            ["1314"   , "中石化"],
            ["8150"   , "南茂"],
            ["1568"   , "蒼佑"],
            ["2402"   , "毅嘉"],
            ["2617"   , "台航"],
            ["2371"   , "大同"],
            ["2328"   , "廣宇"],
            ["4956"   , "光鋐"],
            ["2885"   , "元大金"],
            ["2340"   , "光磊"],
            ["3711"   , "日月光投控"],
            ["6147"   , "頎邦"],
            ["3058"   , "立德"],
            ["5880"   , "合庫金"],
            ["6283"   , "淳安"],
            ["1301"   , "台塑"],
            ["2887"   , "台新金"],
            ["2106"   , "建大"],
            ["8936"   , "國統"],
            ["2357"   , "華碩"],
            ["8358"   , "金居"],
            ["6244"   , "茂迪"],
            ["3707"   , "漢磊"],
            ["4960"   , "誠美材"],
            ["1101"   , "台泥"],
            ["5285"   , "界霖"],
            ["3346"   , "麗清"],
            ["4938"   , "和碩"],
            ["8183"   , "精星"],
            ["8069"   , "元太"]
        ]
    
    var backupStockInfo: [String:Stock] {
        set { }
        get {
            var result: [String:Stock] = [:]
            for array in allStock {
                result[array[0]] = Stock(code: array[0], name: array[1])
            }
            return result
        }
    }
    
    var stockInfo: [String:Stock] = [:]
    
    func goRandom() {
        let time = Int.random(in: 1 ... 5)
        var array: [String] = []
        for _ in 1 ... time {
            if let code = self.allStock.randomElement()?.first, !array.contains(code), let stock = self.stockInfo[code] {
                array.append(code)
                self.stockInfo[code] = Stock(code: stock.code, name: stock.name)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateData"), object: array)
    }
    
    func getAPIData(completion: @escaping(Bool) -> Void) {
        
        let stock = UserDefaults.standard.string(forKey: "search_stock") ?? "0099P"
        let date = (UserDefaults.standard.value(forKey: "search_date") as? Date)?.dateString() ?? "20210322"
        let request = URLRequest(url: URL(string: String(format: "https://www.twse.com.tw/exchangeReport/MI_INDEX?response=json&type=%@&date=%@", stock, date))!)

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.timeoutIntervalForResource = 20.0
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response.debugDescription)
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, AnyObject>, let array = json["data1"] as? [[String]], array.count > 0 {
                self.parseData(dataArray: array)
                completion(true)
            } else {
                self.allStock = self.backupALL
                self.stockInfo = self.backupStockInfo
                completion(false)
            }
        })

        task.resume()
    }
    
    func parseData(dataArray: [[String]]) {
        //data[4]成交值, data[9]漲跌紅綠,
        allStock = []
        stockInfo = [:]
        for data in dataArray {
            var stock = Stock()
            stock.code = data[0]
            stock.name = data[1]
            stock.totalVolumn = data[2]
            stock.volumn = data[3]
            stock.openingPrise = data[5]
            stock.topPrise = data[6]
            stock.bottomPrise = data[7]
            stock.closingPrise = data[8]
            stock.isRed = data[9].contains("red") ? true : false
            stock.spread = data[10]
            stock.bidPrise = data[11]
            stock.bidVolumn = data[12]
            stock.offerPrise = data[13]
            stock.offerVolumn = data[14]
            stock.prise = stock.closingPrise
            stockInfo[stock.code] = stock
            allStock.append([stock.code, stock.name])
        }
    }
}
