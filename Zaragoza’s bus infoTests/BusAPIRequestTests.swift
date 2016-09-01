//
//  BusAPIRequestTests.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import XCTest

class BusAPIRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testParsingPopultedJSON() {
        
        let busStopsData = busStopsDataFromFile("BusStopsPopulated")

        let busStopsRequest = BusStopsAPIRequest()
        
        let busStops = try? busStopsRequest.responseParsing(data: busStopsData)
        XCTAssertNotNil(busStops, "Parsing bus stops should succeed.")
        
        XCTAssertTrue(busStops?.count == 7)
        
        XCTAssertTrue(busStops![0].number == 731)
        XCTAssertTrue(busStops![0].name == "PLZ CANTERAS")
        XCTAssertTrue(busStops![0].lat == 41.63139435772203)
        XCTAssertTrue(busStops![0].lon == -0.886143585091619)
    }

    func testParsingOneLocationJSON() {
        
        let busStopsData = busStopsDataFromFile("BusStopsOneLocation")
        
        let busStopsRequest = BusStopsAPIRequest()
        
        let busStops = try? busStopsRequest.responseParsing(data: busStopsData)
        XCTAssertNotNil(busStops, "Parsing bus stops should succeed.")
        
        XCTAssertTrue(busStops?.count == 1)
        
        XCTAssertTrue(busStops![0].number == 731)
        XCTAssertTrue(busStops![0].name == "PLZ CANTERAS")
        XCTAssertTrue(busStops![0].lat == 41.63139435772203)
        XCTAssertTrue(busStops![0].lon == -0.886143585091619)
    }

    func testParsingEmptyJSON() {
        
        let busStopsData = busStopsDataFromFile("BusStopsEmpty")

        let busStopsRequest = BusStopsAPIRequest()
        
        let busStops = try? busStopsRequest.responseParsing(data: busStopsData)
        XCTAssertNotNil(busStops, "Parsing bus stops should succeed.")
        
        XCTAssertTrue(busStops?.count == 0)
    }

    func busStopsDataFromFile(filename: String) -> NSData {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(filename, ofType: "txt")
        XCTAssertNotNil(path, "Path for resource should be valid")
        
        let busStopsData = NSFileManager.defaultManager().contentsAtPath(path!)
        XCTAssertNotNil(busStopsData, "\(path) not loaded")
        
        return busStopsData!
    }
}
