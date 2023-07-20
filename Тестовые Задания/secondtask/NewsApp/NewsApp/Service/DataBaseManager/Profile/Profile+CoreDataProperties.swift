//
//  Profile+CoreDataProperties.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 19.07.2023.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var birthday: String?
    @NSManaged public var gender: String?
    @NSManaged public var imageUser: Data?
    @NSManaged public var name: String?
    @NSManaged public var id: Int64

}

extension Profile : Identifiable {

}
