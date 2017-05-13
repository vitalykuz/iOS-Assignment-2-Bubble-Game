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


class MenuVC: UIViewController {
	@IBOutlet var nameLabel: UITextField!
	@IBOutlet var bestScoreLabel: UITextField!
	@IBOutlet var highScoreLabel: UITextField!
	
	var nameFromHome = ""

    override func viewDidLoad() {
        super.viewDidLoad()	

		print("Name in Menu: \(nameFromHome)")
        // Do any additional setup after loading the view.
		nameLabel.text = nameFromHome

   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func goBackTaped(_ sender: Any) {
		
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toHomeVC" {
			if segue.destination is HomeScreenVC {
			}
		}
		
	}
	
}
