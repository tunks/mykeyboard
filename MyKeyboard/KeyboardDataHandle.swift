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
    func save(entity: KeyDataEntity)
    func saveAll(entities: [KeyDataEntity])
    func getAll() -> [KeyDataEntity]
}

class KeyboardDataHandle: DataHandle{
    func saveAll(entities: [KeyDataEntity]) {
        
    }
    
    func save(entity: KeyDataEntity) {
        
    }
    
    func getAll() -> [KeyDataEntity] {
        var entities = [KeyDataEntity]()
        entities.append( KeyDataEntity(text: "1"))
        entities.append( KeyDataEntity(text: "2"))
        entities.append( KeyDataEntity(text: "3"))
        entities.append( KeyDataEntity(text: "4"))
        entities.append( KeyDataEntity(text: "5"))

        return entities
    }
    
}
