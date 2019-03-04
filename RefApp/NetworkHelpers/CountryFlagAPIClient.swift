//
//  CountryFlagAPIClient.swift
//  RefApp
//
//  Created by Leandro Wauters on 3/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

struct CountryAPIClient {
    static func searchForCountry(country: String, completion: @escaping (Error?, [Country]?) -> Void) {
        NetworkHelper.shared.performDataTask(endpointURLString: "https://restcountries.eu/rest/v2/name/\(country)", httpMethod: "GET", httpBody: nil) { (error, data, httpResponse) in
            if let error = error{
                print(error)
            }
            guard let response = httpResponse,(200...299).contains(response.statusCode) else {
                completion(error, nil)
                return}
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
    }
    static func searchForCountryFlag(countryAlphaCode: String, completion: @escaping (Error?, [CountryFlag.ResponseWrapper]?) -> Void) {
        NetworkHelper.shared.performDataTask(endpointURLString: "http://countryapi.gear.host/v1/Country/getCountries?pAlpha2Code=\(countryAlphaCode)", httpMethod: "GET", httpBody: nil) { (error, data, httpResponse) in
            if let error = error{
                print(error)
            }
            guard let response = httpResponse,(200...299).contains(response.statusCode) else {
                completion(error, nil)
                return}
            if let data = data {
                do {
                    let countryFlagSearch = try JSONDecoder().decode(CountryFlag.self, from: data)
                    completion(nil, countryFlagSearch.Response)
                    //                    completion(nil, recipes)
                } catch {
                    completion(error, nil)
                }
            }
        }
    }
    static func getCountyAlphaCode(country: String,completion: @escaping(Error?, String?) -> Void){
        var countryAlphaCode: String?
        CountryAPIClient.searchForCountry(country: country) { (error, countries) in
            if let error = error {
                completion(error, nil)
            }
            if let countries = countries {
                countryAlphaCode = countries.first?.alpha2Code
                completion(nil, countryAlphaCode)
            }
        }
    }
    static func getCountryFlagUrl(countryAlpahaCode: String, completion: @escaping(Error?, String?) -> Void){
        var countryFlagURL: String?
        CountryAPIClient.searchForCountryFlag(countryAlphaCode: countryAlpahaCode) { (error, countryFlag) in
            if let error = error {
                completion(error,nil)
            }
            if let countryFlag = countryFlag {
                countryFlagURL = countryFlag.first?.FlagPng
                completion(nil,countryFlagURL)
            }
        }
    }
    
//    static func getCountyFlagURL(country: String,completion: @escaping(Error?, String?) -> Void){
//            var countryFlagURL: String?
//        CountryAPIClient.searchForCountry(country: country) { (error, countries) in
//                if let error = error {
//                    completion(error, nil)
//                }
//                if let countries = countries {
//                    countryFlagURL = countries.first?.flag
//                    completion(nil, countryFlagURL)
//                }
//            }
//        }
}



