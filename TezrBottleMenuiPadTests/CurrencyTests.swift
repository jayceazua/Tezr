//
//  CurrencyTests.swift
//  TezrBottleMenuiPadTests
//
//  Created by Erick Sanchez on 6/24/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import XCTest
@testable import TezrBottleMenuiPad

class CurrencyTests: XCTestCase {
    
    func testInits() {
        let invalidString = "abcd"
        let validString = "12415.82"
        
        XCTAssertNotNil(Currency(validString))
        XCTAssertNil(Currency(invalidString))
        
        XCTAssertNotNil(Currency(1.0))
        XCTAssertNotNil(Currency(100_000.0))
        XCTAssertNotNil(Currency(100_000.01))
        XCTAssertNotNil(Currency(-1.0))
        XCTAssertNotNil(Currency(-100_000.0))
        XCTAssertNotNil(Currency(-100_000.01))
        
    }
    
    func testStringValue() {
        
        XCTAssertEqual(Currency(10.0).stringValue, "$10.00")
        XCTAssertEqual(Currency(1_000.0).stringValue, "$1,000.00")
        XCTAssertEqual(Currency(1_000.01).stringValue, "$1,000.01")
        XCTAssertEqual(Currency(9_999.99).stringValue, "$9,999.99")
        
        XCTAssertEqual(Currency(-1.0).stringValue, "-$1.00")
    }
    
    func testOperations() {
        let curr80_90: Currency = 80.90
        let curr20_20: Currency = 20.20
        
        XCTAssertTrue(curr80_90 > curr20_20)
        XCTAssertFalse(curr80_90 < curr20_20)
        XCTAssertEqual(Float(curr80_90 + curr20_20), 101.10, accuracy: 0.01)
        XCTAssertEqual(curr80_90 - curr20_20, 60.70)
        XCTAssertEqual(Float(curr80_90 * curr20_20), 1_634.18, accuracy: 0.01)
        
        
        XCTAssertTrue(curr80_90 > Double(10))
        XCTAssertFalse(curr80_90 < Double(10))
        XCTAssertEqual(Float(curr80_90 + Double(10.10)), 91.00, accuracy: 0.01)
        XCTAssertEqual(Float(curr80_90 - Double(10.10)), 70.80, accuracy: 0.01)
        XCTAssertEqual(Float(curr80_90 * Double(10.10)), 817.09, accuracy: 0.01)
    }
}
