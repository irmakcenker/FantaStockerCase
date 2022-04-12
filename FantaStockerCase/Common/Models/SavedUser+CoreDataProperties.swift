//
//  SavedUser+CoreDataProperties.swift
//  
//
//  Created by cenker.irmak on 11.04.2022.
//
//

import Foundation
import CoreData


extension SavedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedUser> {
        return NSFetchRequest<SavedUser>(entityName: "SavedUser")
    }

    @NSManaged public var user: User?

}
