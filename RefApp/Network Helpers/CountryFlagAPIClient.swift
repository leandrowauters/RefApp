//
//  CountryFlagAPIClient.swift
//  RefApp
//
//  Created by Leandro Wauters on 3/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

struct CountryFlagAPICleint {
    static func searchForCountry(country: String, completion: @escaping (Error?, [Country]?) -> Void) {
        let endpointURLString = "https://restcountries.eu/rest/v2/name/\(country)"
        guard let url = URL(string: endpointURLString) else {
            print("bad url: \(endpointURLString)")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error, nil)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                    print("bad status code, status code: \(statusCode)")
                    completion(error, nil)
                    return
            }
            if let data = data {
                do {
                    let countryFlagSearch = try JSONDecoder().decode([Country].self, from: data)
                    completion(nil, countryFlagSearch)
//                    completion(nil, recipes)
                } catch {
                    completion(error, nil)
                }
            }
        }
        task.resume()
    }
}



