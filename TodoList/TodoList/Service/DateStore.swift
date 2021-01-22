//
//  DateStore.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/22.
//

import Foundation

class DateStore: DateStoreProtocol {

	func fetchDate(completionHandler: @escaping (() throws -> Date) -> Void) {
		let date = Date()
		completionHandler { return date }
	}

}
