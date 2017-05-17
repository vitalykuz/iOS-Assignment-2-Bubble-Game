//
//  CustomSlider.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 14/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
	override func trackRect(forBounds bounds: CGRect) -> CGRect {
		var newBounds = super.trackRect(forBounds: bounds)
		newBounds.size.height = 12
		return newBounds
	}
}
