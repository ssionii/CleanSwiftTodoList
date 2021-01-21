//
//  Todos+CoreDataProperties.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/21.
//
//

import Foundation
import CoreData


extension Todos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todos> {
        return NSFetchRequest<Todos>(entityName: "Todos")
    }

    @NSManaged public var content: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var creationDate: Date?
    @NSManaged public var id: Int64

}

extension Todos : Identifiable {

}
