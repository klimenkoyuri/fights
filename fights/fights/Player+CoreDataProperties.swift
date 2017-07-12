//
//  Player+CoreDataProperties.swift
//  fights
//
//  Created by Юрий on 12.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var id: Int16
    @NSManaged public var surname: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Int16
    @NSManaged public var club_id: Int16
    @NSManaged public var game: NSSet?
    @NSManaged public var club: Club?
    @NSManaged public var comment: NSSet?

}

// MARK: Generated accessors for game
extension Player {

    @objc(addGameObject:)
    @NSManaged public func addToGame(_ value: Game)

    @objc(removeGameObject:)
    @NSManaged public func removeFromGame(_ value: Game)

    @objc(addGame:)
    @NSManaged public func addToGame(_ values: NSSet)

    @objc(removeGame:)
    @NSManaged public func removeFromGame(_ values: NSSet)

}

// MARK: Generated accessors for comment
extension Player {

    @objc(addCommentObject:)
    @NSManaged public func addToComment(_ value: Comment)

    @objc(removeCommentObject:)
    @NSManaged public func removeFromComment(_ value: Comment)

    @objc(addComment:)
    @NSManaged public func addToComment(_ values: NSSet)

    @objc(removeComment:)
    @NSManaged public func removeFromComment(_ values: NSSet)

}
