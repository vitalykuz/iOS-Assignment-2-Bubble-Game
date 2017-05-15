//
//  GameViewController.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 13/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit



class GameViewController: UIViewController {
	@IBOutlet var countImage: UIImageView!
	var timer: Timer!
	var count: Int = 3
	@IBOutlet var backgroundView: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.segueToGameOverScene), name: NSNotification.Name(rawValue: "segueToGameOverScene"), object: nil)
		
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
	

	
	func updateTimer() {
		
		switch count {
		case 3:
			countImage.image = UIImage(named: "2")
		case 2:
			countImage.image = UIImage(named: "1")
		case 1:
			countImage.image = UIImage(named: "Start")
		case 0:
			timer.invalidate()
			countImage.isHidden = true
			backgroundView.isHidden = true
			startGame()
		default: break
		}
		
		count = count - 1
	}
	
	func startGame() {
		if let view = self.view as! SKView? {
			// Load the SKScene from 'GameScene.sks'
			if let scene = SKScene(fileNamed: "GameScene") {
				// Set the scale mode to scale to fit the window
				scene.scaleMode = .aspectFill
				//scene.scaleMode = .resizeFill
				
				scene.backgroundColor = UIColor(red:0.94, green:0.60, blue:0.60, alpha:0.7)
				// Present the scene
				view.presentScene(scene)
			}
			
			view.ignoresSiblingOrder = true
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}

	
	func segueToGameOverScene(){
		performSegue(withIdentifier: "toGameOverVC", sender: self)
		self.view.removeFromSuperview()
		self.view = nil
	}
	
}
