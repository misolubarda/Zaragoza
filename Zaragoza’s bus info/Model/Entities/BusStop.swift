//
//  BusStop.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import UIKit

class BusStop {
    
    /// Bus stop number.
    private(set) var number: Int
    /// Bus stop name.
    private(set) var name: String
    /// Bus stop location latitude.
    private(set) var lat: Double
    /// Bus stop location longitude.
    private(set) var lon: Double
    
    /// Bus stop map image.
    private(set) var mapImage: NSData?
    /// Bus stop next bus arrival time.
    private(set) var busArrival: BusArrival?
    
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
    
    /**
     Downloading image if needed. If image was already downloaded it is cached in variable mapImage and returned in callback block instantly.
     
     - parameter completion: callback block with downloaded or cached image.
     */
    func getImageWithCompletion(completion: (image: NSData?) -> Void) {
        
        // Returning image if it was already downloaded and cached.
        if let mapImage = mapImage {
            debugPrint("image already exists")
            completion(image: mapImage)
            return
        }
        
        // Issuing request to download image.
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
                //Should log error
                debugPrint("image didn't get downloaded: \(error)")
                completion(image: nil)
            }
        }
    }
    
    /**
     Getting the next arrival time for the bus stop.
     
     - parameter completion: callback block with next arrival time.
     */
    func getNextArrivalWithCompletion(completion: (arrival: BusArrival?) -> Void) {
        
        let request = BusArrivalAPIRequest(busNumber: number)
        
        request.executeWithCompletion { [weak self] (response) in
            do {
                let busArrival = try response()
                self?.busArrival = busArrival
                
                debugPrint("arrival downloaded: \(self?.number) \(busArrival.estimate)")
                completion(arrival: busArrival)
            } catch let error {
                //Should log error
                debugPrint("arrival didn't get downloaded: \(error)")
                completion(arrival: nil)
            }
        }
    }
}

extension BusStop {
    enum BusStopError: ErrorType {
        case Number, Name, Latitude, Longitude
    }
}
