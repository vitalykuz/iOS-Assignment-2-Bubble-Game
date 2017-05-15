//
//  PlayersScorVC.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 14/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PlayersScorVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet var scoreTableView: UITableView!

	var users = [User]()
	var sortedUsersByScore = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

		scoreTableView.delegate = self
		scoreTableView.dataSource = self
		
		self.fetchUser()
	}
	
	func fetchUser() {
		FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
			
			if let dictionary = snapshot.value as? [String: AnyObject] {
				//print("Vitaly: \(snapshot.value)")
				
				let user = User(dictionary: dictionary)
				
				GameValues.bestScore = user.bestScore!
				//print("Game values: \(GameValues.bestScore)")
				//print("User best score: \(user.bestScore)")
				
				self.users.append(user)
				self.users.sort(by: {$0.bestScore! > $1.bestScore!})
				
				
				//this will crash because of background thread, so lets use dispatch_async to fix
				DispatchQueue.main.async(execute: {
					self.scoreTableView.reloadData()
				})
			}
			
		}, withCancel: nil)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = scoreTableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! BestScoreCell
		
		let user = users[indexPath.row]
		cell.configureCell(user: user)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {	
		return users.count
	}
	
	@IBAction func goBackTaped(_ sender: Any) {
		KeychainWrapper.standard.removeObject(forKey: KEY_UID)
		try! FIRAuth.auth()?.signOut()
		GameValues.bestScore = 0.0
		GameValues.timerCount = 10
		performSegue(withIdentifier: "toHomeVC", sender: nil)
	}
	
}
