//
//  CountryListViewModelTest.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import XCTest
@testable import CountryApp

final class CountryListViewModelTest: XCTestCase {
    
    private var viewModel: CountryListViewModel!
    private var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = CountryListViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func test_fetch_success() async {
        mockNetworkManager.mockCountries = [
            Country(name: "France", region: "Europe", code: "FR", capital: "Paris"),
            Country(name: "Germany", region: "Europe", code: "DE", capital: "Berlin")
        ]
        
        await viewModel.fetchCountryList()
        
        XCTAssertEqual(viewModel.countryList.count, 2)
        XCTAssertEqual(viewModel.filteredCountryList.count, 2)
        XCTAssertNil(viewModel.error)
    }
    
    func test_fetch_failure() async {
        mockNetworkManager.shouldReturnError = true
        
        await viewModel.fetchCountryList()
        
        guard case .serverError(let code)? = viewModel.error else {
            XCTFail("Expected serverError")
            return
        }
        
        XCTAssertEqual(code, 500)
    }
    
    func test_search_match() async {
        mockNetworkManager.mockCountries = [
            Country(name: "Spain", region: "Europe", code: "ES", capital: "Madrid"),
            Country(name: "Sweden", region: "Europe", code: "SE", capital: "Stockholm")
        ]
        
        await viewModel.fetchCountryList()
        viewModel.searchOnCountryList("spain")
        
        XCTAssertEqual(viewModel.filteredCountryList.count, 1)
        XCTAssertEqual(viewModel.filteredCountryList.first?.name, "Spain")
    }
    
    func test_search_emptyText() async {
        mockNetworkManager.mockCountries = [
            Country(name: "Brazil", region: "South America", code: "BR", capital: "Brasilia")
        ]
        
        await viewModel.fetchCountryList()
        viewModel.searchOnCountryList("")
        
        XCTAssertEqual(viewModel.filteredCountryList.count, 1)
    }
    
    func test_search_noMatch() async {
        mockNetworkManager.mockCountries = [
            Country(name: "Canada", region: "North America", code: "CA", capital: "Ottawa")
        ]
        
        await viewModel.fetchCountryList()
        viewModel.searchOnCountryList("xyz")
        
        XCTAssertTrue(viewModel.filteredCountryList.isEmpty)
    }
}
