//
//  MenuVC.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 14/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import GameplayKit
import SwiftKeychainWrapper
import Firebase

class MenuVC: UIViewController {

	@IBOutlet var mainSKView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func startButtonTapped(_ sender: Any) {

	}

	@IBAction func topPlayersButtonTapped(_ sender: Any) {
		
	}
	
	@IBAction func settingsButtonTapped(_ sender: Any) {
		
	}
	@IBAction func logoutButtonTapped(_ sender: Any) {
		KeychainWrapper.standard.removeObject(forKey: KEY_UID)
		try! FIRAuth.auth()?.signOut()
		GameValues.bestScore = 0.0
		GameValues.timerCount = 10
		performSegue(withIdentifier: "toHomeVC", sender: nil)
	}
	
}
