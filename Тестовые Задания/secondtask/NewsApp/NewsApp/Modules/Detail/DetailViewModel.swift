//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import Foundation

struct DetailViewModel {
    let title: String
    let creator: String?
    let content: String
    var pubDate: String
    let imageURL: String?
    let linkURL: String
    
    init(with model: NewsArticle) {
        self.title = model.title
        self.creator = model.creator?.joined(separator: ", ")
        self.content = model.content
        self.pubDate = model.pubDate
        self.imageURL = model.imageURL
        self.linkURL = model.link
    }
    
    init(with model: News) {
        self.title = model.title ?? ""
        self.creator = model.creator
        self.content = model.content ?? ""
        self.pubDate = model.date ?? ""
        self.imageURL = model.imageURL
        self.linkURL = model.linkURL ?? ""
    }
}
