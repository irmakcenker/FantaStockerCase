//
//  User+CoreDataProperties.swift
//  
//
//  Created by cenker.irmak on 11.04.2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var name: String?
    @NSManaged public var userName: String?

}
