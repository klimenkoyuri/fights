//
//  Comment+CoreDataProperties.swift
//  fights
//
//  Created by Юрий on 12.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var idplayer: Int16
    @NSManaged public var idgame: Int16
    @NSManaged public var text: String?
    @NSManaged public var player: NSSet?
    @NSManaged public var game: NSSet?

}

// MARK: Generated accessors for player
extension Comment {

    @objc(addPlayerObject:)
    @NSManaged public func addToPlayer(_ value: Player)

    @objc(removePlayerObject:)
    @NSManaged public func removeFromPlayer(_ value: Player)

    @objc(addPlayer:)
    @NSManaged public func addToPlayer(_ values: NSSet)

    @objc(removePlayer:)
    @NSManaged public func removeFromPlayer(_ values: NSSet)

}

// MARK: Generated accessors for game
extension Comment {

    @objc(addGameObject:)
    @NSManaged public func addToGame(_ value: Game)

    @objc(removeGameObject:)
    @NSManaged public func removeFromGame(_ value: Game)

    @objc(addGame:)
    @NSManaged public func addToGame(_ values: NSSet)

    @objc(removeGame:)
    @NSManaged public func removeFromGame(_ values: NSSet)

}
