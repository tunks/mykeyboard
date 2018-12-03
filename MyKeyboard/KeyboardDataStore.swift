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
    var text: String
    
    init(text: String){
        self.text = text
    }
    
    enum CodingKeys: String, CodingKey {
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
        self.text = try values.decode(String.self, forKey: .text)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
    }
}

class KeyboardDataStore: DataStoreDelegate{
    static let shared = KeyboardDataStore()
    let KeyIndex = "KEYBOARD_TEXT_INDEXES"
    static let DEFAULT_KEY_PREFIX = "default_key_"
    static let DEFAULT_KEY_COUNT = "default_key_count"

    func set(key: String, value: KeyboardItem) {
        try? UserDefaults.standard.set(value.encode(), forKey: key)
        self.addKeyIndex(key: key)
    }
    
    func set(key: String, value: String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func set(key: String, value: Int){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get(key: String) -> KeyboardItem? {
        guard let data = UserDefaults.standard.object(forKey: key) else { return nil }
        let value: KeyboardItem = try! KeyboardItem.decode(from: data as! Data)
        return value
    }
    
    func get(key: String) ->String?{
        return UserDefaults.standard.string(forKey: key)
    }
    
    func get(key: String) ->Int?{
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func keys() -> [String] {
        return self.keyIndexes()
    }
    
    func remove(key: String) {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: key)
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
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}

extension KeyboardDataStore{
    private func addKeyIndex(key: String){
        let contains:Bool = keyIndexes().contains(where: { $0 == key })
        if !contains{
            var keys = keyIndexes()
            keys.append(key)
            UserDefaults.standard.set(keys, forKey: KeyIndex)
        }
    }
    
    private func keyIndexes()->[String]{
        guard let keys = UserDefaults.standard.stringArray(forKey: KeyIndex) else { return [] }
        return keys
    }
    
    private func removeKeyIndex(_ key: String){
        var keys = keyIndexes()
        if let index = Int(key){
            keys.remove(at: index)
            UserDefaults.standard.set(keys, forKey: KeyIndex)
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
            self.shared.set(key: key, value: KeyboardItem(text: value!))
            i += 1
            self.shared.set(key: DEFAULT_KEY_COUNT, value: i)
        }
        print(" default values \( self.shared.values().debugDescription)")
    }
}
