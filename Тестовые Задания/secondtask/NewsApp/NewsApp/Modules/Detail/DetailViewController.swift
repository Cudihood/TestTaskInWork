//
//  DetailViewController.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    private var likeUpdateHandler: ((Bool) -> Void)?
    
    private var newsIsLiked: Bool = false {
        didSet {
            likeUpdateHandler?(newsIsLiked)
        }
    }
    
    private var titleLabel = UILabel()
    private var creatorLabel = UILabel()
    private var contentLabel = UILabel()
    private var dateLabel = UILabel()
    
    private let linkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ссылка на источник", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.setTitleColor(Constants.Color.blue, for: .normal)
        button.tintColor = Constants.Color.blue
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
    }()
    
    private let model: DetailViewModel
    private let repository: RepositoryDataProtocol
   
    private let newsImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let scrollView = UIScrollView()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Constants.Color.red
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    init(model: DetailViewModel, repository: RepositoryDataProtocol) {
        self.model = model
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
        updateLikeStatus()
    }
}

// MARK: Setup views

private extension DetailViewController {
    func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = Constants.Color.black
        return label
    }
    
    func setupUI() {
        self.view.backgroundColor = Constants.Color.background
        titleLabel = createLabel()
        creatorLabel = createLabel()
        contentLabel = createLabel()
        dateLabel = createLabel()
        buildUI()
        setDataViews()
        setupLikeButton()
        setupHandler()
    }
    
    func buildUI() {
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(creatorLabel)
        scrollView.addSubview(contentLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(linkButton)
        scrollView.addSubview(newsImageView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
            make.top.equalToSuperview().inset(Constants.Spacing.standart)
        }
        
        creatorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.space)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(creatorLabel.snp.bottom).offset(Constants.Spacing.space)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(Constants.Spacing.space)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
        }
        
        linkButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.Spacing.space)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
        }

        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(linkButton.snp.bottom).offset(Constants.Spacing.space)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
            make.height.equalTo(Constants.Size.big)
            make.bottom.equalToSuperview().inset(Constants.Spacing.standart)
        }
    }
    
    func setDataViews() {
        titleLabel.text = "Заголовок:\n\(model.title)"
        creatorLabel.text = "Автор:\n\(model.creator ?? "-")"
        contentLabel.text = "Описание:\n\(model.content)"
        dateLabel.text = "Дата публикации:\n\(model.pubDate)"
        newsImageView.addImageFrom(url: URL(string: model.imageURL ?? Constants.defaultImageURL))
    }
    
    @objc func buttonTap() {
        if let url = URL(string: model.linkURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func setupLikeButton() {
        likeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: likeButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    func setupHandler() {
        likeUpdateHandler = { isLiked in
            let image = isLiked ? "heart.fill" : "heart"
            self.likeButton.setBackgroundImage(UIImage(systemName: image), for: .normal)
        }
    }
}

//MARK: Work with repository

private extension DetailViewController {
    func updateLikeStatus() {
        newsIsLiked = repository.isNewsSaved(news: model)
    }
    
    @objc func buttonTapped() {
        if newsIsLiked {
            repository.deleteNews(model: model)
        } else {
            repository.saveNews(model: model)
        }
        newsIsLiked.toggle()
    }
}
