//
//  Summary+CoreDataProperties.swift
//  Summarize
//
//  Created by Oliver Zink on 12/5/23.
//
//

import Foundation
import CoreData


extension Summary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Summary> {
        return NSFetchRequest<Summary>(entityName: "Summary")
    }
    
//    @NSManaged public var date: Date?
//    @NSManaged public var text: String?
//    @NSManaged public var title: String?

}

extension Summary : Identifiable {

}
