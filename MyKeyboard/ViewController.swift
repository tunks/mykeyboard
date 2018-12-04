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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         //KeyboardDataStore.registerDefaultsFromSettingsBundle()
        
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
                                    }
                                }
                                $0 <<< NameRow() {
                                    $0.placeholder = "Tag Name"
                                }
        }

    }


}

