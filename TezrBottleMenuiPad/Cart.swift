
//
//  File.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/17/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import Foundation

struct Cart {
    
    private(set) var items: [LineItem]
    
    func increment(item: LineItem) {
        // add item if not in cart, count = 1
        
        // else +1 to to count
        
    }
    
    func decrement(item: LineItem) {
        // -1 to count
        
        // remove item if zero
    }
}

struct LineItem {
    let item: Item
    var count: Int
}
