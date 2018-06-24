//
//  Dollar.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/18/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import Foundation

struct Currency: Decodable, Equatable {
    
    var stringValue: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        
        let formattedString = currencyFormatter.string(from: NSNumber(value: self.value))!
        
        return formattedString
    }
    
    fileprivate let value: Double
    
    init(_ double: Double) {
        self.value = double
    }
    
    init?(_ string: String) {
        if let double = Double(string) {
            self.value = double
        } else {
            return nil
        }
    }
}

extension Currency {
    
    static func +(_ lo: Currency, _ ro: Currency) -> Currency {
        return Currency(lo.value + ro.value)
    }
    
    static func -(_ lo: Currency, _ ro: Currency) -> Currency {
        return Currency(lo.value - ro.value)
    }
    
    static func *(_ lo: Currency, _ ro: Currency) -> Currency {
        return Currency(lo.value * ro.value)
    }

    static func <(_ lo: Currency, _ ro: Currency) -> Bool {
        return lo.value < ro.value
    }
    
    static func >(_ lo: Currency, _ ro: Currency) -> Bool {
        return lo.value > ro.value
    }
    
    static func <(_ lo: Currency, _ ro: Double) -> Bool {
        return lo.value < ro
    }
    
    static func >(_ lo: Currency, _ ro: Double) -> Bool {
        return lo.value > ro
    }
    
    static func +(_ lo: Currency, _ ro: Double) -> Currency {
        return Currency(lo.value + ro)
    }
    
    static func -(_ lo: Currency, _ ro: Double) -> Currency {
        return Currency(lo.value - ro)
    }
    
    static func *(_ lo: Currency, _ ro: Double) -> Currency {
        return Currency(lo.value * ro)
    }
}

extension Currency: ExpressibleByFloatLiteral {
    
    typealias FloatLiteralType = Float
    
    init(floatLiteral value: Float) {
        self.value = Double(value)
    }
}

extension Float {
    init(_ currency: Currency) {
        self = Float(currency.value)
    }
}
