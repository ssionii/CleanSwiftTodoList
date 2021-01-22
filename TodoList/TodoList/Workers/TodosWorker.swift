//
//  TodosWorker.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/21.
//

import Foundation

class TodosWorker
{
	var todosStore: TodosStoreProtocol

	init(todosStore: TodosStoreProtocol)
	{
		self.todosStore = todosStore
	}

	func fetchTodos(completionHandler: @escaping ([Todo]) -> Void)
	{
		todosStore.fetchTodos { (todos: () throws -> [Todo])
			-> Void in
			do {
				let todos = try todos()
				DispatchQueue.main.async {
					completionHandler(todos)
				}
			} catch {
				DispatchQueue.main.async {
					completionHandler([])
				}
			}
		}
	}


	func createTodo(todoToCreate: Todo, completionHandler: @escaping (Todo?) -> Void)
	{
		todosStore.createTodo(todoToCreate: todoToCreate) {
			(todo: () throws -> Todo?) -> Void in
			do {
				let todo = try todo()
				DispatchQueue.main.async {
					completionHandler(todo)
				}
			} catch {
				DispatchQueue.main.async {
					completionHandler(nil)
				}
			}
		}
	}

    func checkTodo(todoIdToCheck: Int, todoRowToCheck: Int, completionHandler: @escaping (Int, Todo?) -> Void)
	{
		todosStore.checkTodo(todoIdToCheck: todoIdToCheck) {
			(row: () throws -> Int, todo: Todo?) -> Void in

			do {
				let row = try row()
				DispatchQueue.main.async {
					completionHandler(row, todo)
				}
			} catch {
				DispatchQueue.main.async {
					completionHandler(0, nil)
				}
			}
		}
	}
}


// MARK: - Todos store API

protocol TodosStoreProtocol
{
	// MARK: CRUD operations - Optional error

	func fetchTodos(completionHandler: @escaping ([Todo], TodosStoreError?) -> Void)
	func createTodo(todoToCreate: Todo, completionHandler: @escaping (Todo?, TodosStoreError?) -> Void)

	// MARK: CRUD operations - Generic enum result type

	func fetchTodos(completionHandler: @escaping TodosStoreFetchTodosCompletionHandler)
	func createTodo(todoToCreate: Todo, completionHandler: @escaping TodosStoreCreateTodoCompletionHandler)

	// MARK: CRUD operations - Inner closure

	func fetchTodos(completionHandler: @escaping (() throws -> [Todo]) -> Void)
	func createTodo(todoToCreate: Todo, completionHandler: @escaping (() throws -> Todo?) -> Void)
	func checkTodo(todoIdToCheck: Int, completionHandler: @escaping (() throws -> Int, Todo?) -> Void)
}


// MARK: - Todos store CRUD operation results

typealias TodosStoreFetchTodosCompletionHandler = (TodosStoreResult<[Todo]>) -> Void
typealias TodosStoreCreateTodoCompletionHandler = (TodosStoreResult<Todo>) -> Void

enum TodosStoreResult<U>
{
	case Success(result: U)
	case Failure(error: TodosStoreError)
}

// MARK: - Orders store CRUD operation errors

enum TodosStoreError: Equatable, Error
{
	case CannotFetch(String)
	case CannotCreate(String)
}
