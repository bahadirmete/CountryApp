//
//  MockNetworkManager.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

@testable import CountryApp
// Mock Network Manager
final class MockNetworkManager: NetworkProtocol {
    var shouldReturnError = false
    var mockCountries: [Country] = []

    func request<T>(from endpoint: Endpoint) async throws -> T where T : Decodable {
        if shouldReturnError {
            throw NetworkError.serverError(500)
        } else if let countries = mockCountries as? T {
            return countries
        } else {
            throw NetworkError.decodingError
        }
    }
}
