//
//  NewsTableViewController.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import UIKit

final class NewsTableViewController: UITableViewController {
    private var model: [NewsArticle] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let repository: RepositoryNetworkProtocol
    
    private let segmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "Title", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Date", at: 1, animated: true)
        segmentControl.selectedSegmentIndex = 1
        return segmentControl
    }()
    
    init(repository: RepositoryNetworkProtocol) {
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
}

// MARK: - Table view data source

extension NewsTableViewController {
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
        let model = DetailViewModel(with: model[indexPath.row])
        let repository = Repository()
        let detailVC = DetailViewController(model: model, repository: repository)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

private extension NewsTableViewController {
    func setupUI() {
        title = "Новости"
        self.tableView.backgroundColor = Constants.Color.background
        self.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        networkResponse()
    }
    
    func networkResponse() {
        repository.searchNews { [weak self] (newsResponse, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            
            if let newsResponse = newsResponse {
                self.model = newsResponse.results.filter { self.checkDate($0.pubDate) }.sorted { $0.pubDate > $1.pubDate }
            }
        }
    }
    
    @objc func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        if selectedSegmentIndex == 0 {
            model.sort { $0.title < $1.title }
        } else {
            model.sort { $0.pubDate > $1.pubDate }
        }
        tableView.reloadData()
    }
    
    func checkDate(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            return false
        }
        let calendar = Calendar.current
        let currentDate = Date()
        let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        let isElementDateLessThanPreviousDate = calendar.compare(date, to: previousDate, toGranularity: .day) != .orderedAscending
        return isElementDateLessThanPreviousDate ? true : false

    }
}
