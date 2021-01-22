//
//  TodoListTableViewCell.swift
//  TodoList
//
//  Created by 60058232 on 2021/01/21.
//

import UIKit

class TodoListTableViewCell : UITableViewCell {

	@IBOutlet weak var checkButton: UIButton!
	@IBOutlet weak var contentLabel: UILabel!

	@IBAction func checkButtonTapped(_ sender: Any) {

	}

	override func awakeFromNib()
	{
		super.awakeFromNib()
	}

	func bindData(content: String, isDone: Bool)
	{
		contentLabel.text = content

		if isDone {
			checkButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            self.contentLabel.textColor = UIColor.lightGray
		} else {
			checkButton.setImage(UIImage(systemName:"rectangle"), for: .normal)
            
            self.contentLabel.textColor = UIColor.black
		}
 	}



}
