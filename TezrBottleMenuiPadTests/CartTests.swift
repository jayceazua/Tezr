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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCartInit() {
        let cart = Cart()
        XCTAssertEqual(cart.lineItems.count, 0)
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
        
        cart.decrement(item: item)
        XCTAssertEqual(cart.items.count, 0)
        XCTAssertEqual(cart.quantity(for: item), 0)
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
}
