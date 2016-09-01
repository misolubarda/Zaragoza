//
//  GoogleMapImageRequest.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import Foundation

struct GoogleMapImageAPIRequest: APIRequest {
    
    /// Required by protocol (see APIRequest)
    var baseURLString: String = "http://maps.googleapis.com/"
    
    /// Required by protocol (see APIRequest)
    var endpointPath: String = "maps/api/staticmap"
    
    /// Required by protocol (see APIRequest)
    var responseQueue: dispatch_queue_t
    
    /// Required by protocol (see APIRequest)
    var responseParsing: ((data: NSData) throws -> NSData) = { (data) in
        return data
    }
    
    /// Required by protocol (see APIRequest)
    var parameters: [String: String]?
    
    init(responseQueue: dispatch_queue_t) {
        self.responseQueue = responseQueue
    }
    
    init() {
        self.responseQueue = dispatch_get_main_queue()
    }
}

extension GoogleMapImageAPIRequest {
    enum GoogleMapImageAPIRequestError: ErrorType {
        case JSONFromData, Locations
    }
}
