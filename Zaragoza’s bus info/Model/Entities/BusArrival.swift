//
//  BusArrival.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 02/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import Foundation

class BusArrival {
    var estimate: Int
    
    init(jsonDict: [[String: AnyObject]]) throws {
        
        var minEstimate: Int?
        
        for estimateElement in jsonDict {
            guard let arrivalTime = estimateElement["estimate"]?.integerValue else {
                continue
            }
            if minEstimate == nil  {
                minEstimate = arrivalTime
            } else if arrivalTime < minEstimate! {
                minEstimate = arrivalTime
            }
        }
        
        guard let foundEstimate = minEstimate else {
            throw BusArrivalError.NoEstimation
        }
        
        self.estimate = foundEstimate
    }    
}

extension BusArrival {
    enum BusArrivalError: ErrorType {
        case NoEstimation
    }
}
