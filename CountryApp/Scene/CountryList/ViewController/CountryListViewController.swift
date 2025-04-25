//
//  CountryListViewController.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import Foundation
import UIKit

private enum Constants {
    static let debouncerDelay: Double = 0.4
    static let pageTitle: String = "Country List"
    static let searchBarPlaceholder: String = "Country List"
}

final class CountryListViewController: UIViewController {
    private let searchDebouncer = Debouncer(delay: Constants.debouncerDelay)
    private let tableView = UITableView()
    private let searchController = UISearchController()
    private var viewModel = CountryListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = Constants.pageTitle
        view.backgroundColor = .systemBackground
        setupTableView()
        setupSearchController()
        
        viewModel.updateList = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        Task {
            await viewModel.fetchCountryList()
            tableView.reloadData()
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryViewCell.self, forCellReuseIdentifier: CountryViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

// MARK: UITableView Operations
extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryViewCell.reuseIdentifier, for: indexPath) as? CountryViewCell else {
            return UITableViewCell()
        }
        let country = viewModel.filteredCountryList[indexPath.row]
        cell.configure(with: country, index: indexPath.row)
        return cell
    }
}

// MARK: UISearchController Operations
extension CountryListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        searchDebouncer.run { [weak self] in
            self?.viewModel.searchOnCountryList(text)
        }
    }
}
