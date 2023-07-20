//
//  Repository.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import Foundation

protocol RepositoryNetworkProtocol {
    func searchNews(comletion: @escaping (NewsResponse?, Error?) -> Void)
}

protocol RepositoryDataProtocol {
    func saveNews(model: DetailViewModel)
    func loadNews() -> [DetailViewModel]?
    func deleteNews(model: DetailViewModel)
    func isNewsSaved(news: DetailViewModel) -> Bool
}

protocol RepositoryProfileProtocol {
    func saveProfile(model: ProfileTableViewModel)
    func loadProfile() -> ProfileTableViewModel?
}

final class Repository {
    private let networkService = NetworkService()
    private let dataManager = NewsDataManager()
    private let profileManager = ProfileDataManager()
}

extension Repository: RepositoryNetworkProtocol {
    func searchNews(comletion: @escaping (NewsResponse?, Error?) -> Void) {
        networkService.request { data, error in
            if let error = error {
                comletion(nil, error)
            }
            let decode = self.decodeJSON(type: NewsResponse.self, from: data)
            comletion(decode, nil)
        }
    }
}

extension Repository: RepositoryProfileProtocol {
    func saveProfile(model: ProfileTableViewModel) {
        profileManager.saveProfile(model: model)
    }
    
    func loadProfile() -> ProfileTableViewModel? {
        profileManager.loadProfile()
    }
}

extension Repository: RepositoryDataProtocol {
    func saveNews(model: DetailViewModel) {
        dataManager.saveNews(model: model)
    }
    
    func loadNews() -> [DetailViewModel]? {
        dataManager.loadNews()
    }
    
    func deleteNews(model: DetailViewModel) {
        dataManager.deleteNews(news: model)
    }
    
    func isNewsSaved(news: DetailViewModel) -> Bool {
        dataManager.searchNewsByTitle(newsTitle: news.title) != nil
    }
}

private extension Repository {
    func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }
        do {
            let objects = try decoder.decode(type, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
