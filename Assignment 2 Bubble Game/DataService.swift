//
//  DataService.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 13/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
	static let dataService =  DataService()
	
	private var _REF_BASE = DB_BASE
	private var _REF_USERS = DB_BASE.child("users")
	private var _REF_BEST_SCORE = DB_BASE.child("users").child("bestScore")
	
	
	var REF_BASE: FIRDatabaseReference {
		return _REF_BASE
	}
	
	var REF_USERS: FIRDatabaseReference {
		return _REF_USERS
	}
	
	var REF_BEST_SCORE: FIRDatabaseReference {
		return _REF_BEST_SCORE
	}

	func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
		REF_USERS.child(uid).updateChildValues(userData)
	}
	
	func updateBestScoreInDB(uid: String, userData: Dictionary<String, Any>) {
		REF_USERS.child(uid).updateChildValues(userData)
	}

	func updateBestScore(userData: Dictionary<String, Any>) {
		REF_USERS.updateChildValues(userData)
	}
}
