//
//  User.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 14/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import Foundation

public class User: NSObject {
	
	var name: String?
	var email: String?
	var bestScore: Int?
	
	init(dictionary: [String: Any]) {
		self.name = dictionary["name"] as? String ?? ""
		self.email = dictionary["email"] as? String ?? ""
		self.bestScore = dictionary["bestScore"] as? Int ?? 0
	}
}
