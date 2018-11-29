//
//  LocationEntity+CoreDataProperties.swift
//  cse335f18_ClassProject-archer_patrick
//
//  Created by Patrick Archer on 11/19/18.
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var buildingDescription: String?
    @NSManaged public var buildingImage: NSData?
    @NSManaged public var buildingName: String?
    @NSManaged public var ratingCleanliness: Int16
    @NSManaged public var ratingPopularity: Int16
    @NSManaged public var ratingEofA: Int16

}
