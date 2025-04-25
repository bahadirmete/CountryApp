//
//  NetworkError.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknown
}
