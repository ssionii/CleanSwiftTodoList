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

	func fetchTodo(id: Int, completionHandler: @escaping (Todo?) -> Void)
	{
		todosStore.fetchTodo(id: id) { (todo: () throws -> Todo?)
			-> Void in
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


	func createTodo(title: String, content: String, completionHandler: @escaping (Todo?) -> Void)
	{
		todosStore.createTodo(title: title, content: content) {
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
	func fetchTodos(completionHandler: @escaping (() throws -> [Todo]) -> Void)
	func fetchTodo(id: Int, completionHandler: @escaping (() throws -> Todo?) -> Void)
	func createTodo(title: String, content: String, completionHandler: @escaping (() throws -> Todo?) -> Void)
	func checkTodo(todoIdToCheck: Int, completionHandler: @escaping (() throws -> Int, Todo?) -> Void)
}
