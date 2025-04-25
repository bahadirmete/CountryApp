//
//  CountryListViewModel.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import Foundation

protocol CountryListViewModelProtocol {
    func fetchCountryList() async
    func searchOnCountryList(_ searchText: String)
}

final class CountryListViewModel: CountryListViewModelProtocol {
    
    private let networkManager: NetworkProtocol
    private(set) var error: NetworkError?
    private(set) var countryList: [Country] = []
    private(set) var filteredCountryList: [Country] = []
    var updateList: (() -> Void)?
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // MARK: Private Functions
    private func setCountrylist(list: [Country]) {
        self.filteredCountryList = list
        self.countryList = list
    }
    
    // MARK: Request for Country List
    func fetchCountryList() async {
        do {
            let response: [Country] = try await networkManager.request(from: APIEndpoint.getCountryList)
            setCountrylist(list: response)
        } catch let error as NetworkError {
            print(error)
            self.error = error
        } catch {
            print(error)
            self.error = .unknown
        }
    }
    
    func searchOnCountryList(_ searchText: String) {
        defer { updateList?() }
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !trimmedText.isEmpty else {
            filteredCountryList = countryList
            return
        }
        
        filteredCountryList = countryList.filter {
            $0.searchableText.contains(trimmedText)
        }
    }
}
