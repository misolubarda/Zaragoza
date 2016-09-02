//
//  BusArrivalAPIRequest.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 02/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import Foundation

struct BusArrivalAPIRequest: APIRequest {
    
    /// Required by protocol (see APIRequest)
    var baseURLString: String = "http://api.dndzgz.com/"
    
    /// Required by protocol (see APIRequest)
    var endpointPath: String {
        get {
            return "services/bus/\(busNumber)"
        }
    }
    
    /// Required by protocol (see APIRequest)
    var responseQueue: dispatch_queue_t
    
    /// Required by protocol (see APIRequest)
    var responseParsing: ((data: NSData) throws -> BusArrival) = { (data) in
        guard let jsonString = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
            throw BusArrivalAPIRequestError.JSONFromData
        }

        guard let estimates = jsonString["estimates"] as? [[String: AnyObject]] else {
            throw BusArrivalAPIRequestError.Locations
        }

        let busArrival: BusArrival = try BusArrival(jsonDict: estimates)
        
        return busArrival
    }
    
    /// Required by protocol (see APIRequest)
    var parameters: [String: String]?
    
    /// Bus number to query arrival time for.
    var busNumber: Int
    
    init(busNumber: Int, responseQueue: dispatch_queue_t = dispatch_get_main_queue()) {
        self.responseQueue = responseQueue
        self.busNumber = busNumber
    }
}

extension BusArrivalAPIRequest {
    enum BusArrivalAPIRequestError: ErrorType {
        case JSONFromData, Locations
    }
}
