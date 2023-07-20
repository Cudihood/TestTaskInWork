//
//  NewsModel.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let results: [NewsArticle]
}

struct NewsArticle: Codable {
    let title: String
    let link: String
    let creator: [String]?
    let content: String
    let pubDate: String
    let imageURL: String?
    let language: String
}
