
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
     - returns: the quantity for the given item if it's in the cart. Otherwise, return
     0
     */
    func quantity(for item: Item) -> Int {
        if let foundItemInCart = self.lineItems[item.sku] {
            return foundItemInCart.quantity
        } else {
            return 0
        }
    }
    
    /**
     update the quantity for the given item
     
     - postcondition: if the new quantity is zero, remove the item from the cart.
     if the item is not currently in the cart, add it and set its quanatity
     */
    mutating func setQuantity(for item: Item, to newQuantity: Int) {
        if let foundItemInCart = self.lineItems[item.sku] {
            if newQuantity != 0 {
                foundItemInCart.quantity = newQuantity
            } else {
                self.lineItems.removeValue(forKey: item.sku)
            }
        } else {
            guard newQuantity != 0 else { return }
            
            let newItemLineItem = LineItem(item: item, quantity: newQuantity)
            lineItems[item.sku] = newItemLineItem
        }
    }
    
    mutating func increment(item: Item) {
        
        // else +1 to to quantity
        if let itemInCart = lineItems[item.sku] {
            itemInCart.quantity += 1
            
        // add item if not in cart, quantity = 1
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
        if lineItemForItem.quantity == 1 {
            lineItems.removeValue(forKey: item.sku)
            
        // -1 to quantity
        } else {
            lineItemForItem.quantity -= 1
        }
    }
}

class LineItem {
    let item: Item
    var quantity: Int
    
    init(item: Item, quantity: Int = 1) {
        self.item = item
        self.quantity = quantity
    }
}
