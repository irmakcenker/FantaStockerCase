//
//  Post+CoreDataProperties.swift
//  
//
//  Created by cenker.irmak on 11.04.2022.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var image: Data?
    @NSManaged public var text: String?
    @NSManaged public var owner: User?

}
