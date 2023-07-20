//
//  CitiesTableViewController.swift
//  CitiesSingleton
//
//  Created by danil.tsirkunov  on 17.07.2023.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    private let dataManager = DataManager()
    private let cities = CitySingleton.shared
    private var filterCities = [City]()
    
    @IBOutlet private weak var searchBarOutlet: UISearchBar!
    @IBOutlet private weak var searchCapitalOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction private func searchByCapital(_ sender: Any) {
        if searchCapitalOutlet.tintColor == UIColor.systemBlue {
            filterCities = cities.getCapitalCities()
            searchCapitalOutlet.tintColor = .systemGray
        } else {
            filterCities = cities.cities
            searchCapitalOutlet.tintColor = .systemBlue
        }
        tableView.reloadData()
    }
}

extension CitiesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.showsReorderControl = true
        cell.textLabel?.text = filterCities[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataManager.deleteCity(city: filterCities[indexPath.row])
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue", let detailVC = segue.destination as? DetailViewController, let index = tableView.indexPathForSelectedRow {
            detailVC.setCity(city: filterCities[index.row])
        }
    }
}

extension CitiesTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCities = searchText.isEmpty ? cities.cities : cities.getCities(in: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

private extension CitiesTableViewController {
    func configure() {
        dataManager.loadCities()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        searchBarOutlet.delegate = self
        filterCities = cities.cities
    }
}
