//
//  Todo+CoreDataProperties.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/22.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var content: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var creationDate: Date?
    @NSManaged public var title: String?

}

extension Todo : Identifiable {

}
