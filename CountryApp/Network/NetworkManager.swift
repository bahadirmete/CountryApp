//
//  NetworkManager.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

final class NetworkManager: NetworkProtocol {
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            
            return try decoder.decode(T.self, from: data)
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknown
        }
    }
}

