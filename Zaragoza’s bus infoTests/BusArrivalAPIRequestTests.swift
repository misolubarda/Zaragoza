//
//  BusArrivalAPIRequestTests.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 02/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import Foundation

import XCTest

class BusArrivalAPIRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParsingPopultedJSON() {
        
        let arrivalsData = dataFromFile("BusArrivalsPopulated")
        
        let arrivalsRequest = BusArrivalAPIRequest(busNumber: 0)
        
        let arrival = try? arrivalsRequest.responseParsing(data: arrivalsData)
        XCTAssertNotNil(arrival, "Parsing bus arrival should succeed.")
        
        XCTAssertTrue(arrival?.estimate == 8)
    }
    
    func testParsingOneLocationJSON() {
        
        let arrivalsData = dataFromFile("BusArrivalsOneEstimate")
        
        let arrivalsRequest = BusArrivalAPIRequest(busNumber: 0)
        
        let arrival = try? arrivalsRequest.responseParsing(data: arrivalsData)
        XCTAssertNotNil(arrival, "Parsing bus arrival should succeed.")
        
        XCTAssertTrue(arrival?.estimate == 12)
    }
    
    func testParsingEmptyJSON() {
        
        let arrivalsData = dataFromFile("BusArrivalsEmpty")
        
        let arrivalsRequest = BusArrivalAPIRequest(busNumber: 0)
        
        let arrival = try? arrivalsRequest.responseParsing(data: arrivalsData)
        XCTAssertNil(arrival, "Parsing bus arrival should NOT succeed.")        
    }
    
    func dataFromFile(filename: String) -> NSData {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(filename, ofType: "txt")
        XCTAssertNotNil(path, "Path for resource should be valid")
        
        let data = NSFileManager.defaultManager().contentsAtPath(path!)
        XCTAssertNotNil(data, "\(path) not loaded")
        
        return data!
    }
}
