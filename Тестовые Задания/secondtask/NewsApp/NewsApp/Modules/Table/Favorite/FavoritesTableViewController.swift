//
//  FavoritesTableViewController.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    private var model: [DetailViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let repository: RepositoryDataProtocol
    
    
    init(repository: RepositoryDataProtocol) {
        self.repository = repository
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataResponse()
    }
}
    // MARK: - Table view data source

extension FavoritesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? NewsTableViewCell else { return cell }
        let model = NewsCellModel(model: model[indexPath.row])
        cell.configure(with: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(model: model[indexPath.row], repository: repository)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

private extension FavoritesTableViewController {
    func setupUI() {
        title = "Избранные"
        self.tableView.backgroundColor = Constants.Color.background
        self.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
    }
    
    func dataResponse() {
        model = repository.loadNews() ?? []
    }
}
