//
//  BestScoreCell.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 14/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

class BestScoreCell: UITableViewCell {

	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var scoreLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func configureCell(user: User) {
		self.nameLabel.text = user.name
		self.scoreLabel.text = "\(user.bestScore ?? -1)"
	}
	
}
