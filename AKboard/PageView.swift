//
//  PageUIView.swift
//  AKboard
//
//  Created by Ebrima Tunkara on 12/1/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

class PageView: UIView  {

    var index: Int?
    var tableView: UITableView!
    var keyPhrases : [String]?
    var keyboardDelegate: AKboardActionDelegate?
    let cellSpacingHeight: CGFloat = 5

    // Designated Init method
    init(index: Int, backgroundColor: UIColor) {
        super.init(frame: .zero)
        keyPhrases = ["Technical is dispatched",
                      "Wifi Configuration issue",
                      "Customer reported Issue",
                      "No issue Found"];
        setup()
        self.index =  index
        self.backgroundColor = backgroundColor
        
    }
    
    init(index: Int, backgroundColor: UIColor, keyboardItems: [KeyboardItem] ) {
        super.init(frame: .zero)
        keyPhrases = keyboardItems.map({$0.text})
        setup()
        self.index =  index
        self.backgroundColor = backgroundColor
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup(){
       tableView = UITableView(frame: .zero)
       //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")B
        tableView.register(PageTableCell.self, forCellReuseIdentifier: "MyCell")

       //tableView.sizeToFit()
       tableView.translatesAutoresizingMaskIntoConstraints = false
       //tableView.allowsSelection = true
        //tableView.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        tableView.isUserInteractionEnabled = true

       self.addSubview(tableView)
        // Creating and activating the constraints
        NSLayoutConstraint.activate([
          tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
          tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
          tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
          //tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
          tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10),
          //tableView.widthAnchor.constraint(equalTo: self.widthAnchor , constant: -100)
          tableView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (3/4))
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

extension PageView: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (keyPhrases?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell",
                                                 for: indexPath as IndexPath) as! PageTableCell

        cell.textLabel!.text = "\(keyPhrases![indexPath.row])"
        cell.textLabel?.textColor = .black
        //cell.textLabel?.textColor = .black
        cell.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        cell.layer.borderWidth = CGFloat(cellSpacingHeight)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
    
        return cell
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Row selected: \(indexPath.description)")
        let currentCell = self.tableView.cellForRow(at: indexPath)
        let text = currentCell?.textLabel?.text;
        keyboardDelegate?.keyboardPhraseSelected(text!)
    }
}

/*
extension PageView{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PageView.dismissKeyboard))
        self.tableView.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard() {
        //self..endEditing(true)
    }
}
 */










