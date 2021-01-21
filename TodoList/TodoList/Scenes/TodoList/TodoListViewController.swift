//
//  TodoListViewController.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/20.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TodoListDisplayLogic: class
{
	func displayTodoList(viewModel: TodoList.FetchTodos.ViewModel)
	func displayUpdatedTodoList(viewModel: TodoList.CheckTodo.ViewModel)
}

class TodoListViewController: UIViewController, TodoListDisplayLogic, UITableViewDelegate, UITableViewDataSource
{
	var interactor: TodoListBusinessLogic?
	var router: (NSObjectProtocol & TodoListRoutingLogic & TodoListDataPassing)?

	// MARK: Object lifecycle

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
	{
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setup()
	}

	// MARK: Setup

	private func setup()
	{
		let viewController = self
		let interactor = TodoListInteractor()
		let presenter = TodoListPresenter()
		let router = TodoListRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor

	}

	// MARK: Routing

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let scene = segue.identifier {
			let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
			if let router = router, router.responds(to: selector) {
				router.perform(selector, with: segue)
			}
		}
	}

	// MARK: View lifecycle

	override func viewDidLoad()
	{
		super.viewDidLoad()

		todoTableView.delegate = self
		todoTableView.dataSource = self

		fetchTodos()
	}
    
	// MARK: - Fetch todos

    var displayedTodos: [TodoList.FetchTodos.ViewModel.DisplayedTodo] = []{
        didSet{
            print("display \(displayedTodos)")
            self.todoTableView.reloadData()
            
        }
    }

	func fetchTodos()
	{
		let request = TodoList.FetchTodos.Request()
		interactor?.fetchTodos(request: request)
	}

	func displayTodoList(viewModel: TodoList.FetchTodos.ViewModel)
	{
        self.router?.dataStore = interactor as! TodoListDataStore
		displayedTodos = viewModel.displayedTodos
	}

	func displayUpdatedTodoList(viewModel: TodoList.CheckTodo.ViewModel)
	{
        displayedTodos[viewModel.row].isDone = viewModel.todo.isDone
		refreshTableView()
	}

	// MARK: - Table view data source

	@IBOutlet weak var todoTableView: UITableView!

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return displayedTodos.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell

		let displayedTodo = displayedTodos[indexPath.row]
		cell.bindData(content: displayedTodo.content, isDone: displayedTodo.isDone)

		cell.checkButton.tag = indexPath.row
		cell.checkButton.addTarget(self, action: #selector(checkButtonConnected), for: .touchUpInside)

		return cell
	}

	func refreshTableView()
	{
		self.todoTableView?.reloadData()
	}

	@objc func checkButtonConnected(sender : UIButton!) {
		sender.isSelected = !sender.isSelected

		self.displayedTodos[sender.tag].isDone = !self.displayedTodos[sender.tag].isDone

        let request = TodoList.CheckTodo.Request(id: self.displayedTodos[sender.tag].id, row: sender.tag)

		interactor?.checkTodo(request: request)
        refreshTableView()
	}
}
