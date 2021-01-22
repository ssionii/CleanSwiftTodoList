//
//  CoreDataManager.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/21.
//

import UIKit
import CoreData

class CoreDataManager {
	static let shared: CoreDataManager = CoreDataManager()

	let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
	lazy var context = appDelegate?.persistentContainer.viewContext

	let modelName: String = "Todo"

	func getTodos(ascending: Bool = false) -> [Todo] {
		var models: [Todo] = [Todo]()

		if let context = context {
			let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: ascending)
			let fetchRequest: NSFetchRequest<NSManagedObject>
				= NSFetchRequest<NSManagedObject>(entityName: modelName)
			fetchRequest.sortDescriptors = [idSort]

			do {
				if let fetchResult: [Todo] = try context.fetch(fetchRequest) as? [Todo] {
					models = fetchResult
				}
			} catch let error as NSError {
				print("Could not fetch🥺: \(error), \(error.userInfo)")
			}
		}

		return models

	}

	func saveTodo(title: String, content: String,
				  isDone: Bool, creationDate: Date, onSuccess: @escaping ((Todo, Bool) -> Void)) {
        
        
		if let context = context,
		   let entity: NSEntityDescription
			= NSEntityDescription.entity(forEntityName: modelName, in: context) {
            
            // id 값 구하기
            var lastId: Int = 0
            let fetchRequest: NSFetchRequest<NSManagedObject>
                = NSFetchRequest<NSManagedObject>(entityName: modelName)
            do {
                if let fetchResult: [Todo] = try context.fetch(fetchRequest) as? [Todo] {

					if fetchResult.count != 0 {
						lastId = Int(fetchResult[fetchResult.count-1].id)
					} else {
						lastId = 0
					}
                }
            } catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
            
            
            
			if let todo: Todo = NSManagedObject(entity: entity, insertInto: context) as? Todo {
                todo.id = Int64(lastId + 1)
				todo.title = title
				todo.content = content
				todo.isDone = isDone
				todo.creationDate = creationDate

				contextSave { success in
					onSuccess(todo, success)
				}
			}
		}
	}

	func checkTodo(id: Int64, onSuccess: @escaping ((Bool) -> Void))
    {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)

		do {
			if let results: [Todo] = try context?.fetch(fetchRequest) as? [Todo] {
				if results.count != 0 {
					let objectUpdate = results[0] as NSManagedObject
					objectUpdate.setValue(!results[0].isDone, forKey: "isDone")
					try context?.save()
				}
			}

		} catch let error as NSError {
			print("Could not fatch🥺: \(error), \(error.userInfo)")
			onSuccess(false)
		}

		contextSave { success in
			onSuccess(success)
		}

	}
}

extension CoreDataManager {
	fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
		let fetchRequest: NSFetchRequest<NSFetchRequestResult>
			= NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
		fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
		return fetchRequest
	}

	fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
		do {
			try context?.save()
			onSuccess(true)
		} catch let error as NSError {
			print("Could not save🥶: \(error), \(error.userInfo)")
			onSuccess(false)
		}
	}
}
