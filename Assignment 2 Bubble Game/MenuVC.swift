//
//  MenuVC.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 13/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import SwiftKeychainWrapper


class MenuVC: UIViewController {
	@IBOutlet var nameLabel: UITextField!
	@IBOutlet var bestScoreLabel: UITextField!
	@IBOutlet var highScoreLabel: UITextField!
	
	var bestScore = 18
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.updateBestScore()
		
//		DataService.dataService.REF_USERS.observe(.value, with: { (snapshot) in
//			if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
//				for snap in snapshot {
//					print("Snap: \(snap)")
//					if var dict = snap.value as? Dictionary<String, Any> {
//						//dict["bestSCore"] = self.bestScore
//					}
//				}
//			}
//		})
//
//		
//		let users = DataService.dataService.REF_USERS
//		let query = users.queryOrdered(byChild: "bestScore")
//		query.observeSingleEvent(of: .value, with: { (snapshot) in
//			let bestScore = snapshot.childSnapshot(forPath: "bestScore").value as! Int
//			print("Best score \(bestScore)")
//			//let newAmount = cardAmount + 31
//			users.updateChildValues(["bestScore": self.bestScore])/*<------ CRITICAL*/
//		})
		
   }
	
	func updateBestScore() {
		let uid = FIRAuth.auth()?.currentUser?.uid
		
		//DataService.dataService.updateBestScoreInDB(uid: uid!, userData: ["bestScore": self.bestScore])
		
		
		DataService.dataService.REF_BASE.observeSingleEvent(of: .value, with: { snapshot in
			
			if !snapshot.exists() { return }
			
			//print(snapshot)

			let topScore = snapshot.childSnapshot(forPath: "bestScore").value as! Int
			print("Best Score of all \(topScore)")
			
		})
		
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func goBackTaped(_ sender: Any) {
		KeychainWrapper.standard.removeObject(forKey: KEY_UID)
		try! FIRAuth.auth()?.signOut()
		performSegue(withIdentifier: "toHomeVC", sender: nil)
	}
	
	

}
