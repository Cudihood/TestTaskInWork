//
//  NewsDataManager.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import UIKit
import CoreData

final class NewsDataManager {
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
        return NewsDataManager.persistentContainer.viewContext
    }()
    
    func saveNews(model: DetailViewModel) {
        let data = News(context: context)
        data.title = model.title
        data.content = model.content
        data.date = model.pubDate
        data.creator = model.creator
        data.linkURL = model.linkURL
        data.imageURL = model.imageURL
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении новости: \(error.localizedDescription)")
        }
    }
    
    
    func loadNews() -> [DetailViewModel]? {
        let request = News.fetchRequest()
        do {
            let news = try context.fetch(request)
            let newsDataArray = news.compactMap { news in
                DetailViewModel(with: news)
            }
            return newsDataArray
        } catch let error as NSError {
            print("Не удалось загрузить новость. Ошибка: \(error)")
            return nil
        }
    }
    
    func deleteNews(news: DetailViewModel) {
        let request: NSFetchRequest<News> = News.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", news.title)
        do {
            let news = try context.fetch(request)
            if let news = news.first {
                context.delete(news)
                try context.save()
            }
        } catch {
            print("Failed to delete news: \(error.localizedDescription)")
        }
    }
    
    func searchNewsByTitle(newsTitle: String) -> DetailViewModel? {
        let request: NSFetchRequest<News> = News.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", newsTitle)
        request.fetchLimit = 1
        do {
            let news = try context.fetch(request)
            if let news = news.first {
                return DetailViewModel(with: news)
            } else {
                return nil
            }
        } catch {
            print("Failed to search news by Title: \(error.localizedDescription)")
            return nil
        }
    }
}

