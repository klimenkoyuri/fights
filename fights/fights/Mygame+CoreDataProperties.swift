//
//  Mygame+CoreDataProperties.swift
//  fights
//
//  Created by Юрий on 22.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import Foundation
import CoreData


extension Mygame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mygame> {
        return NSFetchRequest<Mygame>(entityName: "Mygame")
    }

    @NSManaged public var player2: NSObject?
    @NSManaged public var myscore: NSObject?
    @NSManaged public var hisscore: NSObject?

}
