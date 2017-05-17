//
//  GameScene.swift
//  Assignment 2 Bubble Game
//
//  Created by Vitaly Kuzenkov on 13/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import Foundation

struct GameValues {
	static var score: Double = 0;
	static var bestScore: Double = 0;
	static var gameSeconds: Int! = 20
	static var timerCount: Int = 10
	static var maxNumberOfBubbles: Int = 15
}


class GameScene: SKScene {
	
	//keeps the list of all bubbles images (textures) I have in assests folder
	var bubbleTextures = [SKTexture]()
	
	var bubbles = [SKSpriteNode]()
	var timerLabel: SKLabelNode?
	var scoreLabel: SKLabelNode?
	var highScoreLabel: SKLabelNode?
	var timer: Timer!
	var currentlyClickedBubbleName:String = ""
	var comboMultiplication: Double = 1;
	var numberOfTheSameBubblesClicked: Int = 1
	
	
	override func didMove(to view: SKView) {
		
		// add bubble images from Assets
		bubbleTextures.append(SKTexture(imageNamed: "bubbleRed"))
		bubbleTextures.append(SKTexture(imageNamed: "bubblePink"))
		bubbleTextures.append(SKTexture(imageNamed: "bubbleGreen"))
		bubbleTextures.append(SKTexture(imageNamed: "bubbleBlue"))
		bubbleTextures.append(SKTexture(imageNamed: "bubbleGray"))
		
		self.getBestScore()
		
		//creates a wall that cannot be passed by bubbles
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.gravity = CGVector.zero

		GameValues.score = 0.0
		
		createRandomBubbles(maxNumberOfBubbles: GameValues.maxNumberOfBubbles)
		
		createLabels()
		
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
	}
	
	func updateTimer() {
		if (GameValues.timerCount == 0) {
			gameOver()
			return
		}
		
		GameValues.timerCount -= 1
		
		timerLabel?.text = "Timer: \(GameValues.timerCount)"
		
		removeBubbleFromScreen()
		createRandomBubbles(maxNumberOfBubbles: GameValues.maxNumberOfBubbles)
	}
	
	func removeBubbleFromScreen() {
		let diceRoll = Int(arc4random_uniform(UInt32(bubbles.count)))
		for _ in 0...diceRoll {
			if(bubbles.count > 0) {
				let randomIndex = Int(arc4random_uniform(UInt32(bubbles.count - 1)))
				let randomBubble = bubbles[randomIndex]
				
				removeBubbleWithAnimation(bubble: randomBubble)
				
				bubbles.remove(at: randomIndex)
			}
		}
	}
	
	func createRandomBubbles(maxNumberOfBubbles: Int) {
		let diceRoll = Int(arc4random_uniform(UInt32(maxNumberOfBubbles - bubbles.count)))
		for _ in 0...diceRoll {
			generateBubbleWithProbability()
		}
	}
	
	func gameOver() {
		timer.invalidate()
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segueToGameOverScene"), object: nil)
	}
	
	func createLabels() {
		
		timerLabel = self.childNode(withName: TIME_LABEL_NODE) as? SKLabelNode
		timerLabel?.text = "Timer: \(GameValues.timerCount)"
		
		scoreLabel = self.childNode(withName: SCORE_LABEL_NODE) as? SKLabelNode
		scoreLabel?.text = "Score: \(GameValues.score)"
		
		highScoreLabel = self.childNode(withName: HIGH_SCORE_LABEL_NODE) as? SKLabelNode
		highScoreLabel?.text = "High Score: \(GameValues.bestScore)"
	}
	
	func createBubble(with index: Int) {
		
		// creates a new Sprite node from the array of all images (textures)
		let bubble = SKSpriteNode(texture: bubbleTextures[index])
		bubble.name = String(index)
		
		// gives it the position of z = 1, so that it appears above any background
		bubble.zPosition = 1
		
		addChild(bubble)
		
		// adds the new bubble to array of bubbles on screen to later use
		bubbles.append(bubble)
		
		// makes it appear somewhere randomly inside the game screen
		let xPosition = GKARC4RandomSource.sharedRandom().nextInt(upperBound: 800)
		var yPosition = GKARC4RandomSource.sharedRandom().nextInt(upperBound: 1300)
		
		//makes the bubble appear outside the footer (high score) and header (timer and score). 150 is the height of the nodes
		if (yPosition <= 150) {
			yPosition = 150 + yPosition
		} else if (yPosition >= 1200) {
			yPosition = yPosition - 150
		}
		
		bubble.position = CGPoint(x: xPosition, y: yPosition)
		
		let scale = CGFloat(GKRandomSource.sharedRandom().nextUniform())
		bubble.setScale(max(0.7, scale))
		
		bubble.alpha = 0
		bubble.run(SKAction.fadeIn(withDuration: 0.5))
		
		configurePhysics(for: bubble)
	}
	
	func configurePhysics(for bubble: SKSpriteNode) {
		
		bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.width / 2)
		bubble.physicsBody?.linearDamping = 0.0
		bubble.physicsBody?.angularDamping = 0.0
		bubble.physicsBody?.restitution = 1.0
		bubble.physicsBody?.friction = 0.0
		
		//random number between -200 and 200 to set up a direction to move
		let motionX = GKRandomSource.sharedRandom().nextInt(upperBound: 400) - 200
		let motionY = GKRandomSource.sharedRandom().nextInt(upperBound: 400) - 200
		
		//moves the buble to the direction
		bubble.physicsBody?.velocity = CGVector(dx: motionX, dy: motionY)
		bubble.physicsBody?.angularVelocity = CGFloat(GKRandomSource.sharedRandom().nextUniform())
	}
	
	func pop(_ node: SKSpriteNode) {
		guard let index = bubbles.index(of: node) else {
			return
		}
		bubbles.remove(at: index)

		calculateScore(node)
		
		node.physicsBody = nil
		node.name = nil
		
		let fadeOut = SKAction.fadeOut(withDuration: 0.3)
		let scaleUp = SKAction.scale(by: 1.5, duration: 0.3)
		scaleUp.timingMode = .easeOut
		let group = SKAction.group([fadeOut, scaleUp])
		
		let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
		node.run(sequence)
		
		run(SKAction.playSoundFileNamed(POP_SOUND, waitForCompletion: false))
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		let touch:UITouch = touches.first! as UITouch
		let positionInScene = touch.location(in: self)
		let touchedNode = self.atPoint(positionInScene)
		
		if let name = touchedNode.name
		{
			if name == TIME_LABEL_NODE || name == SCORE_LABEL_NODE || name == HIGH_SCORE_LABEL_NODE
			{
				touchedNode.isUserInteractionEnabled = false
			} else {
				pop(touchedNode as! SKSpriteNode)
				return
			}
		}
	}
	
	func generateBubbleWithProbability() {
		let number  =  randomNumber(probabilities: [0.4,0.3,0.15,0.10,0.05])
		createBubble(with: number)
	}
	
	// code was found on http://stackoverflow.com/questions/30309556/generate-random-numbers-with-a-given-distribution
	func randomNumber(probabilities: [Double]) -> Int {
		// Sum of all probabilities (so that we don't have to require that the sum is 1.0):
		let sum = probabilities.reduce(0, +)
		// Random number in the range 0.0 <= rnd < sum :
		let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
		// Find the first interval of accumulated probabilities into which `rnd` falls:
		var accum = 0.0
		for (i, p) in probabilities.enumerated() {
			accum += p
			if rnd < accum {
				return i
			}
		}
		// This point might be reached due to floating point inaccuracies:
		return (probabilities.count - 1)
	}
	
	func calculateScore(_ node: SKSpriteNode) {
		
		if (node.name == "0") {
			calculateCombo(node)
			GameValues.score += 1 * comboMultiplication
		} else if (node.name == "1") {
			calculateCombo(node)
			GameValues.score += 2 * comboMultiplication
		} else if (node.name == "2") {
			calculateCombo(node)
			GameValues.score += 5 * comboMultiplication
		} else if (node.name == "3") {
			calculateCombo(node)
			GameValues.score += 8 * comboMultiplication
		} else if (node.name == "4") {
			calculateCombo(node)
			GameValues.score += 10 * comboMultiplication
		}
		
		scoreLabel?.text = "Score: \(GameValues.score)"
		
		//checks if the current score > best score
		if (GameValues.score >= GameValues.bestScore) {
			GameValues.bestScore = GameValues.score
			highScoreLabel?.text = "High Score: \(GameValues.score)"
		}
	}
	
	func calculateCombo(_ node: SKSpriteNode) {
		if currentlyClickedBubbleName == node.name {
			comboMultiplication = 1.5;
			numberOfTheSameBubblesClicked += 1
			print(numberOfTheSameBubblesClicked)
			
			// TO_DO refactor this
			if (numberOfTheSameBubblesClicked == 3 ) {
				run(SKAction.playSoundFileNamed(COMBO_3X, waitForCompletion: false))

			}

			if (numberOfTheSameBubblesClicked == 5 ) {
				run(SKAction.playSoundFileNamed(COMBO_5X, waitForCompletion: false))
				numberOfTheSameBubblesClicked = 0
			}
		} else {
			comboMultiplication = 1;
			numberOfTheSameBubblesClicked = 1
		}
		currentlyClickedBubbleName = node.name!
	}
	
	func removeBubbleWithAnimation( bubble: SKSpriteNode) {
		let fadeOut = SKAction.fadeOut(withDuration: 0.2)
		let scaleUp = SKAction.scale(by: 1.5, duration: 0.2)
		scaleUp.timingMode = .easeOut
		let group = SKAction.group([fadeOut, scaleUp])
		
		let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
		bubble.run(sequence)
	}

	func getBestScore() {
		let ref = DataService.dataService.REF_BASE
		_ = ref.child("users").child("bestScore").observeSingleEvent(of: .value, with: { (snapshot) in
			GameValues.bestScore = snapshot.value as! Double
		})
	}
	
}
