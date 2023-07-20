//
//  MainTabBarController.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import Foundation

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let repository = Repository()
        let newsVC = NewsTableViewController(repository: repository)
        
        let favoritesVC = FavoritesTableViewController(repository: repository)
        
        let profileVC = ProfileViewController(repository: repository)
        
        viewControllers = [generateNavigationController(rootViewController: newsVC, title: "Новости", image: UIImage(systemName: "newspaper")),
                           generateNavigationController(rootViewController: favoritesVC, title: "Избранные", image: UIImage(systemName: "heart")),
                           generateNavigationController(rootViewController: profileVC, title: "Профиль", image: UIImage(systemName: "person.crop.circle"))]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Constants.Color.blue,
            .font: UIFont.preferredFont(forTextStyle: .title1)
            ]
        navigationVC.navigationBar.titleTextAttributes = titleTextAttributes
        return navigationVC
    }
}
