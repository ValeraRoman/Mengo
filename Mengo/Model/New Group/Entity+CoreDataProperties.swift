//
//  Entity+CoreDataProperties.swift
//  Mengo
//
//  Created by Macbook Air 13 on 31.03.2021.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?

}

extension Entity : Identifiable {

}
