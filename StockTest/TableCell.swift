//
//  TableCell.swift
//  StockTest
//
//  Created by HahaSU on 2021/3/22.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {
    
    weak var scrollDelegate: ScrollDelegate?
    
    @IBOutlet var name: UILabel!
    var stock: Stock = Stock() {
        didSet {
            for i in 0 ... 14 {
                let label = self.viewWithTag(i+1) as? UILabel
                label?.text = textOfStock(index: i)
                label?.textColor = stock.isRed ? .red : .green
            }
        }
    }

    var nowPoint: CGPoint = .zero
    var goVertical = true
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        let widthMax = UIScreen.main.bounds.size.width / 4 * 12
        var tableview: UIView? = self
        while !(tableview?.isKind(of: UITableView.self) ?? false) {
            tableview = tableview?.superview
        }
        
        var heightMAX = tableview?.frame.size.height ?? (UIScreen.main.bounds.size.height - 100)
        if CGFloat(FakeAPI.shared.selectedCode.count * 44) > heightMAX {
            heightMAX = CGFloat(FakeAPI.shared.selectedCode.count * 44)
        }
        heightMAX -= tableview?.frame.size.height ?? (UIScreen.main.bounds.size.height - 100)
        
        if recognizer.state == .began {
            UIView.setAnimationsEnabled(false)
            let volid = recognizer.velocity(in: tableview)
            if abs(volid.x) > abs(volid.y) {
                goVertical = false
                nowPoint = cellCollection.contentOffset
            } else {
                goVertical = true
                nowPoint = (tableview as? UIScrollView)?.contentOffset ?? .zero
            }
        } else if recognizer.state == .ended {
            UIView.setAnimationsEnabled(true)
            if goVertical {
                let velid = recognizer.velocity(in: tableview)
                var y = ((tableview as? UIScrollView)?.contentOffset.y ?? nowPoint.y) - velid.y/3
                if y < 0 { y = 0 }
                else if y > heightMAX { y = heightMAX }
                (tableview as? UIScrollView)?.contentOffset.y = y
            } else {
                let velid = recognizer.velocity(in: cellCollection)
                var x = cellCollection.contentOffset.x - velid.x/3
                if x < 0 { x = 0 }
                else if x > widthMax { x = widthMax }
                cellCollection.contentOffset.x = x
                scrollDelegate?.didScroll(to: cellCollection.contentOffset)
            }

        } else if recognizer.state == .changed {
            
            if goVertical {
                let transfer = recognizer.translation(in: tableview)
                var y = ((tableview as? UIScrollView)?.contentOffset.y ?? nowPoint.y) - transfer.y/5
                if y < 0 { y = 0 }
                else if y > heightMAX { y = heightMAX }
                (tableview as? UIScrollView)?.contentOffset.y = y
                nowPoint = (tableview as? UIScrollView)?.contentOffset ?? .zero
            } else {
                let transfer = recognizer.translation(in: cellCollection)
                var x = cellCollection.contentOffset.x - transfer.x/5
                if x < 0 { x = 0 }
                else if x > widthMax { x = widthMax }
                cellCollection.contentOffset = CGPoint(x: x, y: 0)
                scrollDelegate?.didScroll(to: cellCollection.contentOffset)
                nowPoint = cellCollection.contentOffset
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(cellCollection)
        cellCollection.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellCollection.leadingAnchor.constraint(equalTo: name.trailingAnchor).isActive = true
        cellCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
        gesture.delegate = self
        cellCollection.addGestureRecognizer(gesture)
        
        setupLabel()
    }
    
    var cellCollection: UIScrollView = {
        let width = UIScreen.main.bounds.size.width / 4
        let view = UIScrollView()
        view.backgroundColor = .black
        view.contentSize = CGSize(width: width * 15, height: 44)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupLabel() {
        let width = UIScreen.main.bounds.size.width / 4
        for i in 0 ... 14 {
            let label = UILabel(frame: CGRect(x: width * CGFloat(i), y: 0, width: width, height: 44))
            label.text = i.stringValue
            label.textAlignment = .center
            label.tag = i+1
            label.textColor = .white
            label.font = .systemFont(ofSize: 20)
            label.adjustsFontSizeToFitWidth = true
            cellCollection.addSubview(label)
        }
    }
    
    func textOfStock(index: Int) -> String {
        switch index {
        case 0:
            return stock.prise
        case 1:
            return stock.spread
        case 2:
            return (stock.spread.floatValue/stock.closingPrise.floatValue).percentString
        case 3:
            return stock.bidPrise
        case 4:
            return stock.offerPrise
        case 5:
            return stock.volumn
        case 6:
            return stock.totalVolumn
        case 7:
            return stock.bidVolumn
        case 8:
            return stock.offerVolumn
        case 9:
            return stock.topPrise
        case 10:
            return stock.bottomPrise
        case 11:
            return stock.openingPrise
        case 12:
            let high = stock.topPrise.floatValue
            let low = stock.bottomPrise.floatValue
            return ((high-low)/stock.closingPrise.floatValue).percentString
        case 13:
            return stock.closingPrise
        case 14:
            return Date().stringValue()
        default:
            return ""
        }
    }
}
