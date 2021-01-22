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

	let modelName: String = "Todos"

	func getTodos(ascending: Bool = false) -> [Todo] {
		var models: [Todos] = [Todos]()

		if let context = context {
			let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: ascending)
			let fetchRequest: NSFetchRequest<NSManagedObject>
				= NSFetchRequest<NSManagedObject>(entityName: modelName)
			fetchRequest.sortDescriptors = [idSort]

			do {
				if let fetchResult: [Todos] = try context.fetch(fetchRequest) as? [Todos] {
					models = fetchResult
				}
			} catch let error as NSError {
				print("Could not fetch🥺: \(error), \(error.userInfo)")
			}
		}


		var todos : [Todo] = [Todo]()

		for model in models {
			todos.append(Todo(id: Int(model.id), content: model.content!, isDone: model.isDone, creationDate: model.creationDate!))
		}

		return todos
	}

	func saveTodo(content: String,
				  isDone: Bool, creationDate: Date, onSuccess: @escaping ((Bool) -> Void)) {
        
        
		if let context = context,
		   let entity: NSEntityDescription
			= NSEntityDescription.entity(forEntityName: modelName, in: context) {
            
            // id 값 구하기
            var lastId: Int = 0
            let fetchRequest: NSFetchRequest<NSManagedObject>
                = NSFetchRequest<NSManagedObject>(entityName: modelName)
            do {
                if let fetchResult: [Todos] = try context.fetch(fetchRequest) as? [Todos] {

					if fetchResult.count != 0 {
						lastId = Int(fetchResult[fetchResult.count-1].id)
					} else {
						lastId = 0
					}
                }
            } catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
            
            
            
			if let todo: Todos = NSManagedObject(entity: entity, insertInto: context) as? Todos {
                todo.id = Int64(lastId + 1)
				todo.content = content
				todo.isDone = isDone
				todo.creationDate = creationDate

				contextSave { success in
					onSuccess(success)
				}
			}
		}
	}

	func checkTodo(id: Int64, onSuccess: @escaping ((Bool) -> Void))
    {

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)

		do {
			if let results: [Todos] = try context?.fetch(fetchRequest) as? [Todos] {
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
