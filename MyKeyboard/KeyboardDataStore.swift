//
//  DataStore.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 9/3/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation

extension Encodable {
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

struct KeyboardItem: Equatable, Hashable{
    var key: String?
    var text: String = ""
    
    init(text: String){
        self.text = text
    }
    
    init(text: String, key: String){
        self.init(text: text)
        self.key = key
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case text
    }
}

protocol DataStoreDelegate {
    func set(key: String, value: KeyboardItem)
    func get(key: String ) -> KeyboardItem?
    func remove(key: String)
    func keys()->[String]
    func values()->[KeyboardItem]
}

extension KeyboardItem:  Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try values.decode(String.self, forKey: .key)
        self.text = try values.decode(String.self, forKey: .text)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(text, forKey: .text)
    }
}

class KeyboardDataStore: DataStoreDelegate{
    static let shared = KeyboardDataStore()
    let KeyIndex = "KEYBOARD_TEXT_INDEXES"
    static let DEFAULT_KEY_PREFIX = "default_key_"
    static let USER_KEY_PREFIX = "USER_KEY_"
    static let DEFAULT_KEY_COUNT = "default_key_count"
    static let APP_GROUP = "group.dev.tunks"
    private var userDefaults: UserDefaults! {
        get{
            return UserDefaults(suiteName: KeyboardDataStore.APP_GROUP)
        }
    }

    func set(key: String, value: KeyboardItem) {
        try? userDefaults.set(value.encode(), forKey: key)
        self.addKeyIndex(key: key)
        debugPrint("data store saved => k: \(key), v: \(value)")
    }
    
    func set(key: String, value: String){
        userDefaults.set(value, forKey: key)
    }
    
    func set(key: String, value: Int){
        userDefaults.set(value, forKey: key)
    }
    
    func get(key: String) -> KeyboardItem? {
        guard let data = userDefaults.object(forKey: key) else { return nil }
        let value: KeyboardItem = try! KeyboardItem.decode(from: data as! Data)
        return value
    }
    
    func get(key: String) ->String?{
        return userDefaults.string(forKey: key)
    }
    
    func get(key: String) ->Int?{
        return userDefaults.integer(forKey: key)
    }
    
    func keys() -> [String] {
        return self.keyIndexes()
    }
    
    func remove(key: String) {
        DispatchQueue.main.async {
            self.userDefaults.removeObject(forKey: key)
            self.removeKeyIndex(key)
        }
    }
    
    func values() -> [KeyboardItem] {
        //clear()
        let keys = keyIndexes()
        //print("keys \(keys)")
        var values: [KeyboardItem] = []
        for k in keys{
            //print("1. key: \(k)")
            let value: KeyboardItem = self.get(key: k)!
            //print("2. value: \(value)")
            values.append(value)
        }
        
        return values
    }
    
    func clear(){
        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        userDefaults.synchronize()
    }
}

extension KeyboardDataStore{
    private func addKeyIndex(key: String){
        let contains:Bool = keyIndexes().contains(where: { $0 == key })
        if !contains{
            var keys = keyIndexes()
            keys.append(key)
            userDefaults.set(keys, forKey: KeyIndex)
        }
    }
    
    private func keyIndexes()->[String]{
        guard let keys = userDefaults.stringArray(forKey: KeyIndex) else { return [] }
        return keys
    }
    
    private func removeKeyIndex(_ key: String){
        var keys = keyIndexes()
        if let index = Int(key){
            keys.remove(at: index)
            userDefaults.set(keys, forKey: KeyIndex)
        }
    }
}

extension KeyboardDataStore {
    static func registerDefaultsFromSettingsBundle()
    {
        print("Registering default values")
       // let path = Bundle.main.path(forResource: "MyKeyboard", ofType: "plist")
        let path = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!
                               .appendingPathComponent("Keyboard.plist")
        
        print("Path  \(path.debugDescription)")

        guard let dictSettings = NSDictionary(contentsOf: path)
        else {
            print("Path not found \(path.debugDescription)")
            return
        }
        
        let keyValues = dictSettings["MyKeyboardDefaultDictionary"] as! [NSDictionary]
        var i = 0;
        for keyValue in keyValues {
            let key = "\(DEFAULT_KEY_PREFIX)\(i)"
            let value = keyValue["keytext"] as? String
            self.shared.set(key: key, value: KeyboardItem(text: value!, key: key))
            i += 1
            self.shared.set(key: DEFAULT_KEY_COUNT, value: i)
        }
        //print(" default values \( self.shared.values().debugDescription)")
    }
}
