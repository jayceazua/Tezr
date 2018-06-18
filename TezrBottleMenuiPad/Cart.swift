
//
//  File.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/17/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import Foundation

struct Cart {
    
    /**
     Items on the cart
     
     Items in the cart have counts of either 1 or greater.
     */
    private(set) var lineItems: [SKU: LineItem]
    
    mutating func increment(item: Item) {
        
        // else +1 to to count
        if let itemInCart = lineItems[item.sku] {
            itemInCart.count += 1
            
        // add item if not in cart, count = 1
        } else {
            let newItemLineItem = LineItem(item: item)
            lineItems[item.sku] = newItemLineItem
        }
    }
    
    mutating func decrement(item: Item) {
        guard let lineItemForItem = lineItems[item.sku] else {
            return debugPrint("item is not in cart")
        }
        
        // remove item if zero
        if lineItemForItem.count == 1 {
            lineItems.removeValue(forKey: item.sku)
            
        // -1 to count
        } else {
            lineItemForItem.count -= 1
        }
    }
}

class LineItem {
    let item: Item
    var count: Int
    
    init(item: Item) {
        self.item = item
        self.count = 1
    }
}
