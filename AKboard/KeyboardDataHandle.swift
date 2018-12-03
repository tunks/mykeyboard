//
//  KeyboardHandle.swift
//  MyKeyboard
//
//  Created by Ebrima Tunkara on 12/2/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation


struct KeyDataEntity{
    var text: String?
}

protocol DataHandle{
    func save(entity: KeyboardItem)
    func getAll() -> [KeyboardPage]
}


class KeyboardDataHandle: DataHandle{
    private var dataStoreDelegate: DataStoreDelegate?
    
    init(){
      self.dataStoreDelegate = KeyboardDataStore()
    }
    
    init(_ delegate: DataStoreDelegate){
        self.dataStoreDelegate = delegate
    }
    
    func save(entity: KeyboardItem) {
        
    }
    
    func getAll() -> [KeyboardPage] {
        let entities = dataStoreDelegate?.values().sorted(by: { $0.text.lowercased() < $1.text.lowercased() })
        var pageDict = [String: KeyboardPage]();
        for item in entities!{
            let key = String(item.text.first!).uppercased()
            if pageDict.keys.contains(key){
                pageDict[key]?.addPageItem(item)
            }
            else{
                pageDict[key] = KeyboardPage(key, item: item)
            }
        }
        return Array(pageDict.values)
    }
    
}

class KeyboardPage{
    static let DEFAULT_PAGE_LIMIT = 4;
    var pageLimit = DEFAULT_PAGE_LIMIT
    private var pageKey: String?
    private var pageItems = [Int: Set<KeyboardItem>]()
    private var currentIndex = 0
    
    init(_ key: String){
        self.pageKey =  key
    }
    
    init(_ key: String, item: KeyboardItem){
        self.pageKey =  key
        self.addPageItem(item)
    }
    
    func addPageItem(_ item: KeyboardItem){
        if(!pageItems.keys.contains(currentIndex)){
            pageItems[currentIndex] = Set<KeyboardItem>()
        }
        
        if (pageItems[currentIndex]?.count)! < self.pageLimit {
            pageItems[currentIndex]?.insert(item)
        }
        else{
            currentIndex += 1
            addPageItem(item)
        }
    }
    
    func pageViews() -> [PageView]{
        var pageViews = [PageView]()
        for (key, value) in pageItems{
            pageViews.append(PageView(index: key, backgroundColor: .orange, keyboardItems: value))
        }
        
        return pageViews
    }
}
