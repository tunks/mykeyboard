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
    var pageIndex: Int?
    
    init(title: String){
        self.title = title;
    }
    
    func button() -> UIButton {
        let button = UIButton()
        button.setTitle(title!, for: .normal)
        button.setTitleColor(.black, for: .normal)
        //button.layer.borderColor = UIColor.lightGray.cgColor
        //button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8.0
        //button.clipsToBounds = true
        button.titleLabel?.font = button.titleLabel?.font.withSize(14)
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
        //print("page selected index \(index)")
        selectButton(index)
    }
    
    @objc func selected(sender : UIButton){
        for button in (stack?.subviews)! as! [UIButton] {
            button.isSelected = button == sender
        }
        let index = (stack?.subviews.index(of: sender))!
        //print("button clicked \(index)")
        selectButton(index)
        delegate?.selectedIndex(index)
    }

    private func selectButton(_ index: Int){
        var position = 0
        for button in (stack?.subviews)! as! [UIButton] {
            if index == position{
                button.isSelected = true
                button.backgroundColor = UIColor.lightGray
            }
            else{
                button.isSelected = false
                button.backgroundColor = stack?.backgroundColor
            }
            position += 1
        }
    }
}

protocol MyPageControlDelegate {
    func selectedIndex(_ index:Int)
}
