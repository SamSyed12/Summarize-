//
//  Summary+CoreDataClass.swift
//  Summarize
//
//  Created by Oliver Zink on 12/5/23.
//
//

import CoreData

@objc(Summary)
public class Summary: NSManagedObject {
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
}

