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
	var currentBestScore: Double! = 0.0

	var gameOverVC: GameOverVC?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		scoreLabel.text = "Score: \(GameValues.score)"
		bestScoreLabel.text = "Best Score: \(GameValues.bestScore)"
		//print("Best Score: \(GameValues.bestScore)")
		//print("Score: \(GameValues.score)")
        // Do any additional setup after loading the view.
		
		self.findUser()
		
		if (self.currentBestScore <= GameValues.score) {
			updateDatabase()
		}
		
    }

	@IBAction func playAgainButtonClicked(_ sender: Any) {
		GameValues.timerCount = 10
		GameValues.score = 0.0
		GameValues.bestScore = currentBestScore
	}

	@IBAction func topPlayersButtonTapped(_ sender: Any) {
	}
	
	func updateDatabase() {
		let userID = FIRAuth.auth()?.currentUser?.uid
		var bestScoreDict = Dictionary<String, Any>()
		bestScoreDict = ["bestScore": GameValues.bestScore]
		DataService.dataService.updateBestScoreInDB(uid: userID!, userData: bestScoreDict)
	}
	
	
	func findUser() {
		let ref = DataService.dataService.REF_BASE
		let userID = FIRAuth.auth()?.currentUser?.uid
		_ = ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			//print("Snap: \(snapshot)")
			
			if let dictionary = snapshot.value as? [String: AnyObject] {
				self.currentBestScore = dictionary["bestScore"] as? Double
				print("Vitaly best score: \(self.currentBestScore)")
			}
		})
	}
}






