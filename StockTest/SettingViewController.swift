//
//  SettingViewController.swift
//  StockTest
//
//  Created by HahaSU on 2021/3/23.
//

import Foundation
import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var updateTime: UITextField!
    @IBOutlet var animationSwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var categoryBtn: UIButton!
    
    weak var delegate: SettingDelegate?
    
    let database = UserDefaults.standard
    
    let stockCategory: [[String]] = [["0099P", "ETF"], ["01", "水泥工業"], ["02", "食品工業"], ["03", "塑膠工業"], ["04", "紡織纖維"], ["05", "電機機械"], ["06", "電器電纜"], ["21", "化學工業"], ["22", "生技醫療業"], ["08", "玻璃陶瓷"], ["09", "造紙工業"], ["10", "鋼鐵工業"], ["11", "橡膠工業"], ["12", "汽車工業"], ["24", "半導體業"], ["25", "電腦及週邊設備業"], ["26", "光電業"], ["27", "通信網路業"], ["28", "電子零組件業"], ["29", "電子通路業"], ["30", "資訊服務業"], ["31", "其他電子業"], ["14", "建材營造"], ["15", "航運業"], ["16", "觀光事業"], ["17", "金融保險"], ["18", "貿易百貨"], ["23", "油電燃氣業"], ["20", "其他"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        datePicker.maximumDate = yesterday
        
        let tooBar: UIToolbar = UIToolbar()
        tooBar.barStyle = .default
        tooBar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(setUpdateTimeAction))]
        tooBar.sizeToFit()
        updateTime.inputAccessoryView = tooBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animationSwitch.isOn = database.bool(forKey: "animation_open")
        updateTime.text = database.string(forKey: "update_time")
        if let date = database.value(forKey: "search_date") as? Date {
            datePicker.date = date
        }
        let stockId = database.string(forKey: "search_stock")
        for stock in stockCategory {
            if stock[0] == stockId {
                categoryBtn.setTitle(stock[1], for: .normal)
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.popoverDismissed()
    }
    
    @IBAction func selectCategory(sender: UIButton) {
        let alert = UIAlertController(title: "請選擇查詢類股", message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = sender
        for item in stockCategory {
            let action = UIAlertAction(title: item[1], style: .default) { (_) in
                self.database.setValue(item[0], forKey: "search_stock")
                sender.setTitle(item[1], for: .normal)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func setUpdateTimeAction() {
        if let second = Int(updateTime.text ?? ""), second >= 10 {
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            let time: TimeInterval = Double(second) / 1000
            appdelegate?.timer?.invalidate()
            appdelegate?.timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { (_) in
                FakeAPI.shared.goRandom()
            })
            database.setValue(updateTime.text, forKey: "update_time")
            updateTime.endEditing(true)
            return
        }
        updateTime.text = "10"
        let alert = UIAlertController(title: nil, message: "請重新輸入10以上的整數", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchValueChange(sender: UISwitch) {
        database.setValue(sender.isOn, forKey: "animation_open")
    }
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        database.setValue(sender.date, forKey: "search_date")
    }
}
