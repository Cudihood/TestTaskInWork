//
//  ProfileDataManager.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 19.07.2023.
//

import UIKit
import CoreData

final class ProfileDataManager {
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
        return ProfileDataManager.persistentContainer.viewContext
    }()
    
    func searchById(id: Int64) -> Profile? {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        do {
            let profilel = try context.fetch(request)
            if let profilel = profilel.first {
                return profilel
            } else {
                return nil
            }
        } catch {
            print("Failed to search news by Title: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveProfile(model: ProfileTableViewModel) {
        let data: Profile?
        if let profile = searchById(id: model.id) {
            data = profile
        } else {
            data = Profile(context: context)
        }
        
        data?.name = model.name
        data?.birthday = model.birthday
        data?.gender = model.gender
        data?.imageUser = model.imageUser
        data?.id = model.id
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении: \(error.localizedDescription)")
        }
    }
    
    
    func loadProfile() -> ProfileTableViewModel? {
        let request = Profile.fetchRequest()
        do {
            let profile = try context.fetch(request)
            return ProfileTableViewModel(with: profile.first ?? nil)
        } catch let error as NSError {
            print("Не удалось загрузить. Ошибка: \(error)")
            return nil
        }
    }
}


