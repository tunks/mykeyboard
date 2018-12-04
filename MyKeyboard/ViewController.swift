//
//  ViewController.swift
//  MyKeyboard
//
//  Created by Ebrima Tunkara on 11/29/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {
    let datastore = KeyboardDataStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        KeyboardDataStore.registerDefaultsFromSettingsBundle()
        let keyItems = datastore.values()        
        super.viewDidLoad()
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "MyKeyboard Phrases") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add New"
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "New phrase"
                                    }.onChange({row in
                                        let key = "\(KeyboardDataStore.USER_KEY_PREFIX)\(index)"
                                        self.updateRowValueOnDatastore(row,key: key)
                                    })
                                }
                                
                                for item in keyItems{
                                    $0 <<< NameRow() {
                                        $0.value = item.text
                                    }.onChange({row in
                                        self.updateRowValueOnDatastore(row, key: item.key!)
                                    })
                                }
        }

    }
    
    private func updateRowValueOnDatastore(_ row: NameRow, key: String, item: KeyboardItem? = nil){
        guard let text = row.value
            else{
                return
        }
        let keyItem = KeyboardItem(text: text, key: key)
        debugPrint(keyItem)
        self.datastore.set(key: key, value: keyItem)
    }


}

