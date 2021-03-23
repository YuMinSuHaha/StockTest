//
//  StockSelection.swift
//  StockTest
//
//  Created by HahaSU on 2021/3/21.
//

import Foundation
import UIKit

protocol SettingDelegate: class {
    
    func popoverDismissed()
}

class StockSelection: UIViewController, SettingDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBtn: UIButton!
    
    var dataSource = FakeAPI.shared.allStock
    var stockInfo = FakeAPI.shared.stockInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
        if Reachability.isConnectedToNetwork() {
            searchBtn.isHidden = false
        } else {
            searchBtn.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? SettingViewController)?.delegate = self
    }
    
    func popoverDismissed() {
        loadData()
    }
    
    func loadData() {
        FakeAPI.shared.getAPIData { (sucess) in
            if !sucess {
                let alert = UIAlertController(title: nil, message: "讀取失敗，使用預設資料", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            DispatchQueue.main.async {
                self.dataSource = FakeAPI.shared.allStock
                self.stockInfo = FakeAPI.shared.stockInfo
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func selectAll() {
        FakeAPI.shared.selectedCode = []
        dataSource.forEach({ (array) in
            FakeAPI.shared.selectedCode.append(array.first!)
        })
        tableView.reloadData()
    }
    
    @IBAction func selectNone() {
        FakeAPI.shared.selectedCode = []
        tableView.reloadData()
    }
}

extension StockSelection: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        
        let stock = stockInfo[dataSource[indexPath.row].first ?? ""]
        cell.textLabel?.text = stock?.name
        if FakeAPI.shared.selectedCode.contains(stock?.code ?? "") {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        guard let selected = dataSource[indexPath.row].first else {
            return
        }
        if FakeAPI.shared.selectedCode.contains(selected) {
            cell?.accessoryType = .none
            FakeAPI.shared.selectedCode.removeAll { (code) -> Bool in
                return code == selected
            }
        } else {
            cell?.accessoryType = .checkmark
            FakeAPI.shared.selectedCode.append(selected)
        }
    }
    
}
