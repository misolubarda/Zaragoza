//
//  BusStop.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import UIKit

class BusStop {
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
    
    func getImageWithCompletion(completion: (image: NSData?) -> Void) {
        if let mapImage = mapImage {
            debugPrint("image already exists")
            completion(image: mapImage)
            return
        }
        
        var request = MapImageAPIRequest()
        request.parameters = ["center"  : "\(lat),\(lon)",
                              "zoom"    : "15",
                              "size"    : "150x150",
                              "sensor"  : "true"]
        
        request.executeWithCompletion { [weak self] (response) in
            do {
                let imageData = try response()
                self?.mapImage = imageData
                debugPrint("image downloaded")
                completion(image: imageData)
            } catch let error {
                //Should log error or connect it with crash report
                debugPrint("image didn't get downloaded: \(error)")
                completion(image: nil)
            }
        }
    }
}

extension BusStop {
    enum BusStopError: ErrorType {
        case Number, Name, Latitude, Longitude
    }
}
