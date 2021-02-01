//
//  TodoDetailViewController.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/22.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TodoDetailDisplayLogic: class
{
	func displayTodo(viewModel: TodoDetail.FetchTodo.ViewModel)
}

class TodoDetailViewController: UIViewController, TodoDetailDisplayLogic
{
	var interactor: TodoDetailBusinessLogic?
	var router: (NSObjectProtocol & TodoDetailRoutingLogic & TodoDetailDataPassing)?

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
		let interactor = TodoDetailInteractor()
		let presenter = TodoDetailPresenter()
		let router = TodoDetailRouter()
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
		fetchTodo()
	}

	// MARK: - Fetch todo

	//@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	func fetchTodo()
	{
		let request = TodoDetail.FetchTodo.Request()
		interactor?.fetchTodo(request: request)
	}

	func displayTodo(viewModel: TodoDetail.FetchTodo.ViewModel)
	{
		titleLabel.text = viewModel.title
		contentLabel.text = viewModel.content
		dateLabel.text = viewModel.creationDate
	}
}
