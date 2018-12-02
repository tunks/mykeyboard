//
//  MyPageControl.swift
//  AKboard
//
//  Created by Ebrima Tunkara on 12/2/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

class PageCategory{
    var title: String?
    
    init(title: String){
        self.title = title;
    }
    
    func button() -> UIButton {
        let button = UIButton()
       // let image = UIImage(named: "letter_a")
        button.setTitle(title!, for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
    }
}

class MyPageControl : NSObject{
    var stack : UIStackView? = nil
    var delegate : MyPageControlDelegate?
    
    init(_ categories: [PageCategory]) {
        let array = categories.map({return $0.button()})
        
        stack = UIStackView(arrangedSubviews: array)
        stack?.spacing = 20
        stack?.distribution = .fillEqually
        stack?.alignment = .center
    
        
        super.init()
        
        array.forEach({ button in
            button.addTarget(self, action: #selector(selected(sender:)), for: .touchUpInside)
        })
    }
    
    func selectIndex(_ index:Int){
        for button in (stack?.subviews)! as! [UIButton] {
            button.isSelected = true
        }
    }
    
    @objc func selected(sender : UIButton){
        for button in (stack?.subviews)! as! [UIButton] {
            button.isSelected = button == sender
        }
        delegate?.selectedIndex((stack?.subviews.index(of: sender))!)
    }

}

protocol MyPageControlDelegate {
    func selectedIndex(_ index:Int)
}
