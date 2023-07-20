//
//  NewsCellModel.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import Foundation

struct NewsCellModel {
    let titel: String
    let date: String
    
    init(model: NewsArticle) {
        self.titel = model.title
        self.date = model.pubDate
    }
    
    init(model: DetailViewModel) {
        self.titel = model.title
        self.date = model.pubDate
    }
}
