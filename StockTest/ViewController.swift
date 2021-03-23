//
//  ViewController.swift
//  StockTest
//
//  Created by HahaSU on 2021/3/20.
//

import UIKit

protocol ScrollDelegate: class {
    
    func didScroll(to position: CGPoint)
    
}

class ViewController: UIViewController, ScrollDelegate {
    
    let itemTitleArray = ["成交", "漲跌", "幅度", "買進", "賣出", "單量", "總量", "買量", "賣量", "最高", "最低", "開盤", "振幅", "昨收", "時間"]
    
    var dataArray = FakeAPI.shared.selectedCode
    
    var goVertical: Bool = true
    
    var nowPosition: CGPoint = .zero
    
    @IBOutlet var titleCollection: UICollectionView!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleCollection.register(UINib(nibName: "TitleCell", bundle: nil), forCellWithReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
    }
    
    override func viewWillLayoutSubviews() {
        let screen = UIScreen.main.bounds.size
        if let layout = titleCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: screen.width/4, height: 44)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataArray = FakeAPI.shared.selectedCode
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update(notify:)), name: NSNotification.Name(rawValue: "updateData"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateData"), object: nil)
    }
    
    @objc func update(notify: Notification) {
        if dataArray.count == 0 {
            return
        }
        let animate = UserDefaults.standard.bool(forKey: "animation_open")
        if let updateArray = notify.object as? [String] {
            for index in tableView.indexPathsForVisibleRows ?? [] {
                if updateArray.contains(dataArray[index.row]) {
                    let offset = (index.row+1) * 44 - 2
                    if animate {
                        fireAnimation(index: index, y: offset)
                    } else {
                        tableView.reloadRows(at: [index], with: .none)
                    }
                }
            }
        }
    }
    
    func fireAnimation(index: IndexPath, y: Int) {
        let taView = UIView(frame: CGRect(x: 0, y: y, width: Int(self.tableView.frame.size.width), height: 2))
        taView.backgroundColor = .red
        self.tableView.addSubview(taView)
        self.tableView.reloadRows(at: [index], with: .none)
        UIView.animate(withDuration: 0.5) {
            taView.alpha = 0
        } completion: { (_) in
            taView.removeFromSuperview()
        }
    }
    
    func didScroll(to position: CGPoint) {
        if let array = tableView.visibleCells as? [TableCell] {
            for cell in array {
                (cell.cellCollection as UIScrollView).contentOffset = position
            }
            titleCollection.contentOffset = position
            nowPosition = position
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as? TableCell ?? TableCell()
        if let stock = FakeAPI.shared.stockInfo[dataArray[indexPath.row]] {
            cell.name.text = stock.name
            cell.stock = stock
        }
        if cell.cellCollection.contentOffset != nowPosition {
            cell.cellCollection.contentOffset = nowPosition
        }
        cell.scrollDelegate = self
        cell.name.adjustsFontSizeToFitWidth = true
        return cell
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCell", for: indexPath) as? TitleCell ?? TitleCell()
        cell.name.text = itemTitleArray[indexPath.section]
        cell.name.font = .systemFont(ofSize: 25)
        cell.backgroundColor = .darkGray
        return cell
    }
}
