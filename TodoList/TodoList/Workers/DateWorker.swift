//
//  DateWorker.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/22.
//

import Foundation

class DateWorker
{
	var dateStore: DateStoreProtocol
	
	init(dateStore: DateStoreProtocol)
	{
		self.dateStore = dateStore
	}
	
	func fetchDate(completionHandler: @escaping (Date) -> Void)
	{
		dateStore.fetchDate { (date: () throws -> Date)
			-> Void in
			do {
				let date = try date()
				DispatchQueue.main.async {
					completionHandler(date)
				}
			} catch {
				DispatchQueue.main.async {
					completionHandler(Date())
				}
			}
		}
	}
}

protocol DateStoreProtocol
{
	func fetchDate(completionHandler: @escaping (() throws -> Date) -> Void)
}
