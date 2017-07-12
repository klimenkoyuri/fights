//
//  Club+CoreDataProperties.swift
//  fights
//
//  Created by Юрий on 12.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import Foundation
import CoreData


extension Club {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Club> {
        return NSFetchRequest<Club>(entityName: "Club")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var player: NSSet?

}

// MARK: Generated accessors for player
extension Club {

    @objc(addPlayerObject:)
    @NSManaged public func addToPlayer(_ value: Player)

    @objc(removePlayerObject:)
    @NSManaged public func removeFromPlayer(_ value: Player)

    @objc(addPlayer:)
    @NSManaged public func addToPlayer(_ values: NSSet)

    @objc(removePlayer:)
    @NSManaged public func removeFromPlayer(_ values: NSSet)

}
