//
//  News+CoreDataProperties.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 19.07.2023.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var content: String?
    @NSManaged public var creator: String?
    @NSManaged public var date: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var linkURL: String?
    @NSManaged public var title: String?

}

extension News : Identifiable {

}
