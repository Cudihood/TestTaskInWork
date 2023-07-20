//
//  DataManager.swift
//  CitiesSingleton
//
//  Created by danil.tsirkunov  on 17.07.2023.
//

import UIKit
import CoreData

final class DataManager {
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Не удалось загрузить хранилище данных. Ошибка: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return DataManager.persistentContainer.viewContext
    }()
    
    func saveCity(city: CityModel) {
        let data = City(context: context)
        data.name = city.name
        data.isCapital = city.isCapital ?? false
        data.country = city.country
        data.population = city.population ?? 0
        do {
            try context.save()
            CitySingleton.shared.addCity(data)
        } catch {
            print("Ошибка при сохранении трека: \(error.localizedDescription)")
        }
    }
    
    func loadCities() {
        let request = City.fetchRequest()
        do {
            let city = try context.fetch(request)
            city.forEach { element in
                CitySingleton.shared.addCity(element)
            }
        } catch let error as NSError {
            print("Не удалось загрузить изображение. Ошибка: \(error)")
            return
        }
    }
    
    func deleteCity(city: City) {
        let request: NSFetchRequest<City> = City.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", city.name ?? "")
        do {
            let cities = try context.fetch(request)
            if let city = cities.first {
                context.delete(city)
                try context.save()
                CitySingleton.shared.removeCity(city)
            }
        } catch {
            print("Failed to delete track: \(error.localizedDescription)")
        }
    }
}

