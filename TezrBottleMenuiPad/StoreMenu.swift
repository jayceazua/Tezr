//
//  StoreMenu.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/17/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import Foundation

struct StoreMenu {
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     
     - parameter <#bar#>: <#Consectetur adipisicing elit.#>
     
     - returns: <#Sed do eiusmod tempor.#>
     */
    static let localStore: StoreMenu = {
        
        //load the store categories from menu.plist, which is stored in the bundle
        guard
            let loadedMenuPlistUrl = Bundle.main.url(forResource: "menu", withExtension: "plist"),
            let loadedMenuPlistData = try? Data(contentsOf: loadedMenuPlistUrl),
            let loadedMenu = try? PropertyListDecoder().decode([ItemCategory].self, from: loadedMenuPlistData) else {
                fatalError("plist is not an array of Item Categories")
        }
        
        let store = StoreMenu(categories: loadedMenu)
        
        return store
    }()
    
    let categories: [ItemCategory]
    
    var items: [Item] {
        fatalError("\(#function) not implemented")
    }
}

struct ItemCategory: Decodable {
    let sectionItems: [SectionItem]
}

struct SectionItem: Decodable {
    let title: String
    let items: [Item]
}

struct Item: Decodable {
    let title: String
    let price: Double
}
