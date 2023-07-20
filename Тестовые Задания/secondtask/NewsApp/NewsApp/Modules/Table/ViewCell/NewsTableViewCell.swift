//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import UIKit
import SnapKit

final class NewsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NewsCell"
    
    private let newsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.black
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsLabel.text = nil
    }
    
    func configure(with model: NewsCellModel) {
        self.newsLabel.text = model.titel
        self.dateLabel.text = model.date
    }
}

private extension NewsTableViewCell {
    func setupView() {
        self.backgroundColor = Constants.Color.background
        self.contentView.addSubview(newsLabel)
        self.contentView.addSubview(dateLabel)
        
        newsLabel.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(Constants.Spacing.standart)
            make.top.equalToSuperview().inset(Constants.Spacing.space)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constants.Spacing.standart)
        }
    }
}
