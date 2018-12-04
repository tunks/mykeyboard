//
//  KeyboardHandle.swift
//  MyKeyboard
//
//  Created by Ebrima Tunkara on 12/2/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

struct KeyDataEntity{
    var text: String?
}

protocol DataHandle{
    func getAll() -> [KeyboardPage]
}

protocol PageHandle{
    func addPageItem( _ item: KeyboardItem)
    func addPageItem( _ item: KeyboardItem, key: String?)
    func pages() -> [KeyboardPage]
    func pageViews() -> [PageView]
}

class KeyboardDataHandle: DataHandle{
    var dataStoreDelegate: DataStoreDelegate?
    var pageHandle: PageHandle?
    
    init(){
      self.dataStoreDelegate = KeyboardDataStore()
      self.pageHandle = KeyboardPageHandle()
    }
    
    init(_ delegate: DataStoreDelegate){
        self.dataStoreDelegate = delegate
    }
    
    func getAll() -> [KeyboardPage] {
        let entities = dataStoreDelegate?.values().sorted(by: { $0.text.lowercased() < $1.text.lowercased() })
        for item in entities!{
            let key = String(item.text.first!).uppercased()
            pageHandle?.addPageItem(KeyboardItem(text: item.text), key: key)
        }
        return (pageHandle?.pages())!
    }
    
}

class KeyboardPage{
    var pageKeys = Set<String>()
    var pageIndex = -1
    var pageItems = [KeyboardItem]()
    var count: Int?{
        get {
            return pageItems.count
        }
    }
    
    init(){
    }
    init(_ key: String){
        self.pageKeys.insert(key)
    }
   
    init(_ index: Int){
        self.pageIndex = index
    }
    
    convenience init(_ key: String, item: KeyboardItem){
        self.init(key)
        self.addItem(item)
    }
    
    func addItem(_ item: KeyboardItem){
        pageItems.append(item)
    }
    func addItem(_ item: KeyboardItem, _ key: String){
        pageItems.append(item)
        pageKeys.insert(key)
    }
    
    func pageView() -> PageView{
        return PageView(index: pageIndex, backgroundColor: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0), keyboardItems: pageItems)
    }
    
}

class KeyboardPageHandle: PageHandle{
    private var keyboardPages = [Int: KeyboardPage]();
    private var currentIndex = 0
    static let DEFAULT_PAGE_LIMIT = 4;
    var pageLimit = DEFAULT_PAGE_LIMIT
    
    func addPageItem(_ item: KeyboardItem) {
        if(!keyboardPages.keys.contains(currentIndex)){
            keyboardPages[currentIndex] = KeyboardPage(currentIndex)
        }
        
        if (keyboardPages[currentIndex]?.count)! < self.pageLimit {
            keyboardPages[currentIndex]?.addItem(item)
        }
        else{
            currentIndex += 1
            addPageItem(item)
        }
    }
    
    func addPageItem(_ item: KeyboardItem, key: String?) {
        if(!keyboardPages.keys.contains(currentIndex)){
            keyboardPages[currentIndex] = KeyboardPage(currentIndex)
        }
        
        if (keyboardPages[currentIndex]?.count)! < self.pageLimit {
            keyboardPages[currentIndex]?.addItem(item, key!)
        }
        else{
            currentIndex += 1
            addPageItem(item)
        }
    }
    
    func pageViews() -> [PageView] {
        return keyboardPages.values.map({$0.pageView()})
    }
    
    func pages() -> [KeyboardPage] {
        return Array(keyboardPages.values)
    }
    
}
