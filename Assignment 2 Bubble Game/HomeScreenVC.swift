//
//  HomeScreenVC.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 13/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class HomeScreenVC: UIViewController, UITextFieldDelegate {
	@IBOutlet var emailLabel: TextFieldCustomView!
	@IBOutlet var passwordLabel: TextFieldCustomView!
	@IBOutlet var nameLabel: TextFieldCustomView!

    override func viewDidLoad() {
        super.viewDidLoad()

		emailLabel.delegate = self
		passwordLabel.delegate = self
		nameLabel.delegate = self
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		//checks if i got the uid in key chain
		if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
			performSegue(withIdentifier: MENU_VC, sender: nil)
		}
	}

	@IBAction func logInButtontapped(_ sender: Any) {
		if (emailLabel.text == "" || passwordLabel.text == "" || nameLabel.text == "" ) {
			// TO-DO add an error
			emailLabel.placeholder = "Please provide email"
		} else {
			if let email = emailLabel.text, let password = passwordLabel.text {
				FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
					if error == nil {
						print("Vitaly: Firebase user authenticated")
						if let user = user {
							let userData = ["email" : user.email!, "name" : self.nameLabel.text!] as [String : Any]
							self.saveUserIdToKeyChain(id: user.uid, userData: userData as! Dictionary<String, String>)
						}
					} else {
						FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { ( user , error) in
							if error != nil {
								// TO-DO: password must be at least 6 characters
								print("Vitaly: user creation is failed")
							} else {
								print("Vitaly: User created")
								if let user = user {
									let userData = ["email" : user.email!, "bestScore" : 0.0, "name" : self.nameLabel.text!] as [String : Any]
									self.saveUserIdToKeyChain(id: user.uid, userData: userData )
								}
							}
						})
					}
				})
			}
		}
	}
	
	func saveUserIdToKeyChain(id: String, userData: Dictionary<String, Any>) {
		DataService.dataService.createFirebaseDBUser(uid: id, userData: userData)
		KeychainWrapper.standard.set(id, forKey: KEY_UID)
		performSegue(withIdentifier: MENU_VC, sender: nil)
	}
	
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	// methods below resposible for moving text fields up, when the keyboard appears
	func textFieldDidBeginEditing(_ textField: UITextField) {
		animateViewMoving(up: true, moveValue: 120)
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		animateViewMoving(up: false, moveValue: 120)
	}
	
	func animateViewMoving (up:Bool, moveValue :CGFloat){
		let movementDuration:TimeInterval = 0.3
		let movement:CGFloat = ( up ? -moveValue : moveValue)
		UIView.beginAnimations( "animateView", context: nil)
		UIView.setAnimationBeginsFromCurrentState(true)
		UIView.setAnimationDuration(movementDuration )
		self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
		UIView.commitAnimations()
	}

	
}
