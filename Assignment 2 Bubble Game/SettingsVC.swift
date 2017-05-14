//
//  SettingsVC.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 14/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
	@IBOutlet var bubblesSlider: CustomSlider!
	@IBOutlet var gameSlider: CustomSlider!
	@IBOutlet var numberOfBubblesLabel: UILabel!
	@IBOutlet var gameTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

		
    }
	
	@IBAction func doneButtonTapped(_ sender: Any) {
		GameValues.maxNumberOfBubbles = Int(bubblesSlider.value)
		GameValues.timerCount = Int(gameSlider.value)
	}
	
	
	@IBAction func bubblesSliderChangedValue(_ sender: Any) {
		numberOfBubblesLabel.text = "Number of bubbles in game: \(Int(bubblesSlider.value))"
	}
	
	@IBAction func gameSliderChangedValue(_ sender: Any) {
		gameTimeLabel.text = "Game Time in seconds: \(Int((gameSlider.value)))"
	}

}
