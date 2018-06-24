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
        var items = [Item]()
        for aCategory in self.categories {
            for aSection in aCategory.sectionItems {
                items += aSection.items
            }
        }
        
        return items
    }
}

struct ItemCategory: Decodable {
    let title: String
    let sectionItems: [SectionItem]
}

struct SectionItem: Decodable {
    let title: String
    let items: [Item]
}

typealias SKU = String

struct Item: Decodable {
    let title: String
    let price: Currency
    let sku: SKU
    
    enum CodingKeys: String, CodingKey {
        case title
        case price
        case sku
    }
    
    init(title: String, price: Currency, sku: SKU) {
        self.title = title
        self.price = price
        self.sku = sku
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Item.CodingKeys.self)
        let title: String = try container.decode(String.self, forKey: .title)
        let sku: SKU = try container.decode(SKU.self, forKey: .sku)
        let priceValue: Double = try container.decode(Double.self, forKey: .price)
        
        self.title = title
        self.sku = sku
        self.price = Currency(priceValue)
    }
}
