//
//  GameOverVC.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 15/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class GameOverVC: UIViewController {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var scoreLabel: UILabel!
	@IBOutlet var bestScoreLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.findUser()
		self.updateDatabase()
		
		if (GameValues.bestScore <= GameValues.score) {
			//rename it
			self.updateBestScore()
			
		}
		
		scoreLabel.text = "Score: \(GameValues.score)"
		bestScoreLabel.text = "Top Score: \(GameValues.bestScore)"
    }

	@IBAction func playAgainButtonClicked(_ sender: Any) {
		GameValues.timerCount = 10
		GameValues.score = 0.0
	}

	// TO_DO encapsulate the follwoing an a method. CHeck if it actualy works
	@IBAction func topPlayersButtonTapped(_ sender: Any) {
		GameValues.timerCount = 10
		GameValues.score = 0.0
	}
	
	func updateDatabase() {
		let userID = FIRAuth.auth()?.currentUser?.uid
		var bestScoreDict = Dictionary<String, Any>()
		bestScoreDict = [BEST_SCORE: GameValues.bestScore]
		DataService.dataService.updateBestScoreInDB(uid: userID!, userData: bestScoreDict)
	}
	
	func updateBestScore() {
		var bestScoreDict = Dictionary<String, Any>()
		bestScoreDict = [BEST_SCORE: GameValues.score]
		DataService.dataService.updateBestScore(userData: bestScoreDict)
	}
	
	func findUser() {
		let ref = DataService.dataService.REF_BASE
		let userID = FIRAuth.auth()?.currentUser?.uid
		_ = ref.child(USERS).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				self.nameLabel.text = dictionary[NAME] as? String
			}
		})
	}
}






