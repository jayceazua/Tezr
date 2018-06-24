//
//  CartTests.swift
//  TezrBottleMenuiPadTests
//
//  Created by Erick Sanchez on 6/17/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import XCTest
@testable import TezrBottleMenuiPad

class CartTests: XCTestCase {
    
    func testCartInit() {
        let cart = Cart()
        XCTAssertEqual(cart.lineItems.count, 0)
        XCTAssertEqual(cart.subtotal, 0.0)
        XCTAssertEqual(cart.items.count, 0)
    }
    
    func testSubtotal() {
        var cart = Cart()
        let item80 = Item(title: "80 bucks", price: 80.0, sku: "123")
        let item20 = Item(title: "20 bucks", price: 20.0, sku: "321")
        
        cart.increment(item: item80)
        cart.increment(item: item20)
        
        //subtotal is 100 bucks
        XCTAssertEqual(cart.subtotal, 100.0)
    }
    
    func testAddItemToCart() {
        var cart = Cart()
        let store = StoreMenu.localStore
        let addedItem = store.items[0]
        
        //adding an item
        cart.increment(item: addedItem)
        XCTAssertTrue(cart.lineItems.contains(where: { (arg0) -> Bool in
            let (_, aLineItem) = arg0
            
            return aLineItem.item.sku == addedItem.sku
        }), "Cart.lineItems does not contain the added item")
        
        //checking its quantity and the line item quantity
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.quantity(for: addedItem), 1)
        
        //increment the same item again
        cart.increment(item: addedItem)
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.quantity(for: addedItem), 2)
    }
    
    func testRemoveItemToCart() {
        var cart = Cart()
        let store = StoreMenu.localStore
        let item = store.items[0]
        
        //decremeting an item
        cart.decrement(item: item)
        XCTAssertFalse(cart.lineItems.contains(where: { (arg0) -> Bool in
            let (_, aLineItem) = arg0
            
            return aLineItem.item.sku == item.sku
        }), "Cart.lineItems should not contain the item")
        
        //checking its quantity and the line item quantity
        XCTAssertEqual(cart.items.count, 0)
        XCTAssertEqual(cart.quantity(for: item), 0)
        
        //increment then decrement the same item again
        cart.increment(item: item)
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.quantity(for: item), 1)
        cart.increment(item: item)
        
        //decrement but not remove the item
        cart.decrement(item: item)
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.quantity(for: item), 1)
        
        //decrement again, setting the quanitiy to zero, thus removing it
        cart.decrement(item: item)
        XCTAssertEqual(cart.items.count, 0)
        XCTAssertEqual(cart.quantity(for: item), 0)
    }
    
    func testClearCart() {
        var cart = Cart()
        let store = StoreMenu.localStore
        let item = store.items[0]
        
        cart.increment(item: item)
        
        //clear cart
        cart.clearItems()
        XCTAssertEqual(cart.quantity(for: item), 0)
        XCTAssertEqual(cart.lineItems.count, 0)
    }
    
    func testSettingItemQuantities() {
        var cart = Cart()
        let store = StoreMenu.localStore
        let item = store.items[0]
        
        //set quantity of item not in cart
        cart.setQuantity(for: item, to: 5)
        XCTAssertEqual(cart.quantity(for: item), 5)
        
        //update quantity of item already in cart
        cart.setQuantity(for: item, to: 2)
        XCTAssertEqual(cart.quantity(for: item), 2)
        
        //remove item by setting quantity to zero
        cart.setQuantity(for: item, to: 0)
        XCTAssertEqual(cart.quantity(for: item), 0)
        XCTAssertEqual(cart.lineItems.count, 0)
        
        //ignore removing an item not in cart for new quantities of zero
        cart.setQuantity(for: item, to: 0)
        XCTAssertEqual(cart.lineItems.count, 0)
    }
    
    func testWithoutPurging() {
        var cart = Cart()
        let store = StoreMenu.localStore
        let addedItem = store.items[0]
        
        //default purging setting quantities
        cart.setQuantity(for: addedItem, to: 2, withoutPurging: false)
        XCTAssertEqual(cart.quantity(for: addedItem), 2)
        
        //set quantity to zero and do not remove it from the cart
        cart.setQuantity(for: addedItem, to: 0, withoutPurging: true)
        XCTAssertEqual(cart.quantity(for: addedItem), 0)
        XCTAssertEqual(cart.lineItems.count, 1)
        
        //purge the cart
        cart.purgeLineItems()
        XCTAssertEqual(cart.quantity(for: addedItem), 0)
        XCTAssertEqual(cart.lineItems.count, 0)
    }
}


















