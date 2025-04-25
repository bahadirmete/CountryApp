//
//  EndPoint.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

enum APIEndpoint: Endpoint {
    case getCountryList
    
    var baseURL: String {
        return "https://gist.githubusercontent.com"
    }
    
    var path: String {
        switch self {
        case .getCountryList:
            return "/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCountryList:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
