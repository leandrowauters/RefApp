//
//  NetworkHelper.swift
//  RefApp
//
//  Created by Leandro Wauters on 3/2/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

public final class NetworkHelper {
    private init() {
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 10 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache
    }
    public static let shared = NetworkHelper()
    
    public func performDataTask(endpointURLString: String,
                                httpMethod: String,
                                httpBody: Data?,
                                completionHandler: @escaping (Error?, Data?, HTTPURLResponse?) ->Void) {
        guard let url = URL(string: endpointURLString) else {
            print("Bad URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(error, nil, response as? HTTPURLResponse)
                return
            } else if let data = data {
                completionHandler(nil, data, response as? HTTPURLResponse)
            }
        }
        task.resume() 
}
}