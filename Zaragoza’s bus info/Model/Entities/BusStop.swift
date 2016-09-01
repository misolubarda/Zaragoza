//
//  BusStop.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import Foundation

struct BusStop {
    var number: Int
    var name: String
    var lat: Double
    var lon: Double
    var mapImage: NSData?
    
    init(jsonDict: [String: AnyObject]) throws {
        guard let number = jsonDict["id"]?.integerValue else {
            throw BusStopError.Number
        }
        guard let name = jsonDict["title"] as? String else {
            throw BusStopError.Name
        }
        guard let lat = jsonDict["lat"]?.doubleValue else {
            throw BusStopError.Latitude
        }
        guard let lon = jsonDict["lon"]?.doubleValue else {
            throw BusStopError.Longitude
        }

        self.number = number
        self.name = name
        self.lat = lat
        self.lon = lon
    }
}

extension BusStop {
    enum BusStopError: ErrorType {
        case Number, Name, Latitude, Longitude
    }
}
