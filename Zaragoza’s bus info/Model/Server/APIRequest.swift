//
//  APIProtocol.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import Foundation


/// This protocol specifies the form of API request.
protocol APIRequest {
    
    /// This defines the type of response data.
    associatedtype ResponseType
    
    /// Base URL string of the request.
    var baseURLString: String {get}
    
    /// Endpoint URL path, relative to baseURL
    var endpointPath: String {get}
    
    /// Endpoint parameters
    var parameters: [String: String]? {get}
        
    /// Queue on which to provide response.
    var responseQueue: dispatch_queue_t {get}
    
    /// This function parses response from NSData to specified response type.
    var responseParsing: ((data: NSData) throws -> ResponseType) {get}
}

extension APIRequest {
    
    /**
     Function executes the request with completion block. Response is returned by executing the completion block on the provided queue. All errors (inside completion block and inside dataTaskWithURL completionHandler block) are thrown when completion block is executed.
     
     Usage without error rethrow:
     
         apiRequest.executeWithCompletion() { (response: () throws -> NSData)
            do {
                let response = try response()
                // Continue using response.
     
            }catch let error {
                // Handle error
     
            }
         }
     
     Usege with error rethrow:
     
         //Inside a funciton that throws error
     
         apiRequest.prepareWithCompletion() { (response: () throws -> NSData)
     
            let response = try response()
            // Continue using response.
     
         }
     
     
     - parameter completion: Completion returns APIResponse or throws error if NSURLSession returns NSError.
     */
    func executeWithCompletion(completion: (response: () throws -> ResponseType) -> Void) {
        let session = NSURLSession.sharedSession()
        guard let baseURL = NSURL(string: baseURLString) else {
            completion(response: { throw  APIRequestError.URL })
            return
        }
        guard var url = NSURL(string: endpointPath, relativeToURL: baseURL) else {
            completion(response: { throw APIRequestError.URL })
            return
        }
        if let parameters = parameters {
            let parametersArray = parameters.map { (key, value) in
                return "\(key)=\(value)"
            }
            let parametersString = "?" + parametersArray.joinWithSeparator("&")
            guard let urlWithParameters = NSURL(string: parametersString, relativeToURL: url) else {
                completion(response: { throw APIRequestError.URL })
                return
            }
            url = urlWithParameters
        }
        let dataTask = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            dispatch_async(self.responseQueue, {
                if error == nil {
                    if let data = data {
                        do {
                            let response = try self.responseParsing(data: data)
                            completion(response: { return response})
                        } catch let error {
                            completion(response: { throw error })
                        }
                    } else {
                        completion(response: { throw APIRequestError.NoData })
                    }
                } else {
                    completion(response: { throw APIRequestError.Response(message: error?.localizedDescription) })
                }
            })
        }
        
        dataTask.resume()
    }
}

enum APIRequestError: ErrorType {
    case URL, Response(message: String?), NoData
}

