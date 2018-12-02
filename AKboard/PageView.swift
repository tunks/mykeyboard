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
    private var tableView: UITableView!
    var keyPhrases : [String]?

    // Designated Init method
    init(index: Int, backgroundColor: UIColor) {
        super.init(frame: .zero)
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
        keyPhrases = ["Dispatch not found", "Wifi Configuration issue",  "Customer reported Issue"];
       /*
          let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
          let displayWidth: CGFloat = self.view.frame.width
          let displayHeight: CGFloat = self.view.frame.height
         tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))

       */
       tableView = UITableView(frame: .zero)
       tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
       tableView.dataSource = self
       tableView.delegate = self
       //tableView.sizeToFit()
       tableView.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(tableView)
        // Creating and activating the constraints
        NSLayoutConstraint.activate([
          tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
          tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
          tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
          //tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
          tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
          //tableView.widthAnchor.constraint(equalTo: self.widthAnchor , constant: -100)
          tableView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (2/4))
        ])
    }
}

extension PageView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (keyPhrases?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(keyPhrases![indexPath.row])"
        cell.textLabel?.textColor = .black
        return cell
    }
}
















