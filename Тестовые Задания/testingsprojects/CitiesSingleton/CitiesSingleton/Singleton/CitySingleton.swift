//
//  CitySingleton.swift
//  CitiesSingleton
//
//  Created by danil.tsirkunov  on 17.07.2023.
//

import Foundation

final class CitySingleton {
    static let shared = CitySingleton()
    
    var cities: [City] = []
    
    private init() {}
    
    func addCity(_ city: City) {
        cities.append(city)
    }
    
    func removeCity(_ city: City) {
        if let index = cities.firstIndex(where: { $0.name == city.name }) {
            cities.remove(at: index)
        }
    }
    
    func getCities(in country: String) -> [City] {
        cities.filter { $0.country?.lowercased().contains(country.lowercased()) ?? false }
    }
    
    func getCapitalCities() -> [City] {
        cities.filter { $0.isCapital }
    }
}
