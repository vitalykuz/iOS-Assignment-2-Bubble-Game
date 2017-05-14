//
//  ButtonCustomView.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 13/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit


class ButtonCustoomView: UIButton {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		//defines the parameters for shadows
		layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 1.0).cgColor
		layer.shadowOpacity = 1.0
		layer.shadowRadius = 5.0
		layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
		layer.cornerRadius = 2.0
		
	}
	
}
