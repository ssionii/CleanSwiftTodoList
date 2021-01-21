//
//  CreateTodoViewController.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CreateTodoDisplayLogic: class
{
	func displayCreateTodo(viewModel: CreateTodo.CreateTodo.ViewModel)
}

class CreateTodoViewController: UIViewController, CreateTodoDisplayLogic
{

	var interactor: CreateTodoBusinessLogic?
	var router: (NSObjectProtocol & CreateTodoRoutingLogic & CreateTodoDataPassing)?

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
		let interactor = CreateTodoInteractor()
		let presenter = CreateTodoPresenter()
		let router = CreateTodoRouter()
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
	}

	// MARK: Create todo

	@IBOutlet weak var contentTextField: UITextField!

	@IBAction func saveButtonTapped(_ sender: Any) {

		let content = contentTextField.text

		if content != "" {
			let request = CreateTodo.CreateTodo.Request(todoField: CreateTodo.TodoField(content: content!))
			interactor?.createTodo(request: request)
		} else {
			showTodoFailureAlert(title: "투두 등록 실패", message: "내용을 입력해주세요.")
		}
	}


	func displayCreateTodo(viewModel: CreateTodo.CreateTodo.ViewModel)
	{
		if viewModel.todo != nil {
			router?.routeToTodoList(segue: nil)
		} else {
			showTodoFailureAlert(title: "투두 등록 실패", message: "투두를 다시 등록해주세요.")
		}
	}

	// MARK: Error handling

	private func showTodoFailureAlert(title: String, message: String)
	{
	  let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
	  let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
	  alertController.addAction(alertAction)
	  showDetailViewController(alertController, sender: nil)
	}
}