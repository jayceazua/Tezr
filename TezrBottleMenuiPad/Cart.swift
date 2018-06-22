
//
//  File.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/17/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import Foundation

struct Cart {
    
    var minimumSubtotal: Currency = 10_000.00
    
    var total: Currency {
        return self.lineItems.reduce(0.0) { $0 + $1.value.subtotal }
    }
    
    var remainingAmount: Currency {
        return minimumSubtotal - total
    }
    
    /**
     - returns: all items in the cart
     */
    var items: [Item] {
        return self.lineItems.map({ (_, aLineItem) -> Item in
            return aLineItem.item
        })
    }
    
    //TODO: make private
    
    /**
     Items on the cart
     
     Items in the cart have counts of either 1 or greater.
     */
    private(set) var lineItems: [SKU: LineItem] = [:]
    
    // MARK: - RETURN VALUES
    
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
    
    // MARK: - VOID METHODS
    
    /**
     update the quantity for the given item
     
     - parameter: withoutPurging: if true items will not be removed if quanitties equaling zero
     
     - postcondition: if the new quantity is zero, remove the item from the cart.
     if the item is not currently in the cart, add it and set its quanatity (if withoutPurging is false)
     */
    mutating func setQuantity(for item: Item, to newQuantity: Int, withoutPurging: Bool = false) {
        if self.lineItems[item.sku] != nil {
            if newQuantity != 0 || withoutPurging == true {
                self.lineItems[item.sku]!.quantity = newQuantity
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
        if lineItems[item.sku] != nil {
            lineItems[item.sku]!.quantity += 1
            
        // add item if not in cart, quantity = 1
        } else {
            let newItemLineItem = LineItem(item: item)
            lineItems[item.sku] = newItemLineItem
        }
    }
    
    mutating func decrement(item: Item) {
        guard lineItems[item.sku] != nil else {
            return debugPrint("item is not in cart")
        }
        
        // remove item if zero
        if lineItems[item.sku]!.quantity == 1 {
            lineItems.removeValue(forKey: item.sku)
            
        // -1 to quantity
        } else {
            lineItems[item.sku]!.quantity -= 1
        }
    }
}

struct LineItem {
    let item: Item
    var quantity: Int
    
    var subtotal: Currency {
        return item.price * Double(quantity) 
    }
    
    init(item: Item, quantity: Int = 1) {
        self.item = item
        self.quantity = quantity
    }
}
