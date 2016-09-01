//
//  ZaragozaAPIRequest.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import Foundation

struct BusAPIRequest: APIRequest {
    
    /// Required by protocol (see APIRequest)
    var baseURLString: String = "http://api.dndzgz.com/"
    
    /// Required by protocol (see APIRequest)
    var endpointPath: String = "services/bus"
    
    /// Required by protocol (see APIRequest)
    var responseQueue: dispatch_queue_t
    
    /// Required by protocol (see APIRequest)
    var responseParsing: ((data: NSData) throws -> [BusStop]) = { (data) in
        
        guard let jsonString = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
            throw BusAPIRequestError.JSONFromData
        }
        
        guard let locations = jsonString["locations"] as? [[String: AnyObject]] else {
            throw BusAPIRequestError.Locations
        }
        
        let busStops: [BusStop] = try locations.map { location in
            let busStop = try BusStop(jsonDict: location)
            return busStop
        }
        
        return busStops
    }
    
    init(responseQueue: dispatch_queue_t) {
        self.responseQueue = responseQueue
    }
    
    init() {
        self.responseQueue = dispatch_get_main_queue()
    }
}

extension BusAPIRequest {
    enum BusAPIRequestError: ErrorType {
        case JSONFromData, Locations
    }
}
