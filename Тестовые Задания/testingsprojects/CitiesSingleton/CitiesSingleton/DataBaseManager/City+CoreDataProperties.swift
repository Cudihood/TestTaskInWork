//
//  City+CoreDataProperties.swift
//  CitiesSingleton
//
//  Created by danil.tsirkunov  on 17.07.2023.
//
//

import Foundation
import CoreData

extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var population: Int64
    @NSManaged public var isCapital: Bool

}

extension City : Identifiable {

}
