//
//  TodoStore.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/21.
//

import Foundation
import CoreData

class TodoStore: TodosStoreProtocol {

//	// MARK: - CRUD operations - Optional error
//
//	func fetchTodos(completionHandler: @escaping ([Todo], TodosStoreError?) -> Void) {
//
//		let todos = CoreDataManager.shared.getTodos()
//		completionHandler(todos , nil)
//	}
//
//	func createTodo(todoToCreate: Todo, completionHandler: @escaping (Todo?, TodosStoreError?) -> Void) {
//
//		let todo = todoToCreate
//        CoreDataManager.shared.saveTodo(content: todoToCreate.content, isDone: todoToCreate.isDone, creationDate: todoToCreate.creationDate){ onSuccess in
//		}
//
//		completionHandler(todo, nil)
//	}
//
//	// MARK: - CRUD operations - Generic enum result type
//
//	func fetchTodos(completionHandler: @escaping TodosStoreFetchTodosCompletionHandler) {
//
//		let todos = CoreDataManager.shared.getTodos()
//		completionHandler(TodosStoreResult.Success(result: todos))
//	}
//
//
//	func createTodo(todoToCreate: Todo, completionHandler: @escaping TodosStoreCreateTodoCompletionHandler) {
//
//		let todo = todoToCreate
//
//        CoreDataManager.shared.saveTodo(content: todoToCreate.content, isDone: todoToCreate.isDone, creationDate: todoToCreate.creationDate){
//            onSuccess in
//            print("saved =\(onSuccess)")
//        }
//
//        completionHandler(TodosStoreResult.Success(result: todo))
//
//	}


	// MARK: - CRUD operations - Inner closure

	func fetchTodos(completionHandler: @escaping (() throws -> [Todo]) -> Void) {
		let todos = CoreDataManager.shared.fetchTodos(ascending: true)
		completionHandler { return todos }
	}

	func fetchTodo(id: Int, completionHandler: @escaping (() throws -> Todo?) -> Void) {

		let todo = CoreDataManager.shared.fetchTodo(id: Int64(id))
		completionHandler { return todo }
	}


	func createTodo(title: String, content: String , completionHandler: @escaping (() throws -> Todo?) -> Void) {

		var todoResult: Todo = Todo()
		CoreDataManager.shared.saveTodo(title: title, content: content, isDone: false, creationDate: Date()){ todo, onSuccess in

			todoResult = todo

			print("saved =\(onSuccess)")
		}

		completionHandler { return todoResult }
	}
    
    func checkTodo(todoIdToCheck: Int, completionHandler: @escaping (() throws -> Int, Todo?) -> Void) {
        
        CoreDataManager.shared.checkTodo(id: Int64(todoIdToCheck)){
            onSuccess in
            print("update =\(onSuccess)")
        }
    }
	
}
