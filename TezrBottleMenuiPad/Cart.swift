
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
    private(set) var lineItems: [SKU: LineItem] = [:]
    
    /**
     - returns: all items in the cart
     */
    var items: [Item] {
        return self.lineItems.map({ (_, aLineItem) -> Item in
            return aLineItem.item
        })
    }
    
    /**
     - returns: the count for the given item if it's in the cart. Otherwise, return
     0
     */
    func count(for item: Item) -> Int {
        if let foundItemInCart = self.lineItems[item.sku] {
            return foundItemInCart.count
        } else {
            return 0
        }
    }
    
    /**
     update the quantity for the given item
     
     - postcondition: if the new quantity is zero, remove the item from the cart.
     if the item is not currently in the cart, add it and set its quanatity
     */
    mutating func setCount(for item: Item, to newCount: Int) {
        if let foundItemInCart = self.lineItems[item.sku] {
            if newCount != 0 {
                foundItemInCart.count = newCount
            } else {
                self.lineItems.removeValue(forKey: item.sku)
            }
        } else {
            guard newCount != 0 else { return }
            
            let newItemLineItem = LineItem(item: item, count: newCount)
            lineItems[item.sku] = newItemLineItem
        }
    }
    
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
    
    init(item: Item, count: Int = 1) {
        self.item = item
        self.count = count
    }
}
