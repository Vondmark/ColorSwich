//
//  GameScene.swift
//  ColorSwich
//
//  Created by Mark on 9/19/19.
//  Copyright © 2019 Mark. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum PlayColors {
    static let colors = [
        UIColor(red: 255, green: 0, blue: 0, alpha: 1.0),
        UIColor(red: 0, green: 186, blue: 255, alpha: 1.0),
        UIColor(red: 255, green: 0, blue: 198, alpha: 1.0),
        UIColor(red: 255, green: 204, blue: 0, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case red, blue, purple, yellow
}

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    let scorelabel = SKLabelNode(text: "0")
    var score = 0
    
    var colorBalls = ["redBall","blueBall", "purpleBall", "yellowBall"]
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupPhysics()
        layoutScene()
        
        
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "mainBall")
        colorSwitch.size = CGSize(width: frame.size.width/3 , height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY+colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        scorelabel.fontName = "Arial"
        scorelabel.fontSize = 60.0
        scorelabel.fontColor = UIColor.white
        scorelabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scorelabel.zPosition = ZPositions.label
        addChild(scorelabel)
        
        spawnBall()
    }
    
    func updateScoreLabel() {
        scorelabel.text = "\(score)"
        switch score {
        case 1 ... 10:
            return physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
            
        case 11 ... 20:
            return physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
            
        case 21 ... 30:
            return physicsWorld.gravity = CGVector(dx: 0.0, dy: -4.5)
            
        case 31 ... 40:
            return physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.5)
            
        default:
            return physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
            
        }
    }
    
    func spawnBall() {
        
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: colorBalls[currentColorIndex!]), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: frame.size.width/4, height: frame.size.width/4))
//        colorBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: colorBalls) as! [String]
//        let ball = SKSpriteNode(imageNamed: colorBalls[0])
//        ball.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.setScale(0.3)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball)
    }
    
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
                switchState = newState
        } else {
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.20))
    }
    
    func gameOver() {
        
        UserDefaults.standard.set(score, forKey: "Score")
        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let mainMenuScene = MainMenuScene(size: view!.bounds.size)
        view!.presentScene(mainMenuScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name  == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColorIndex == switchState.rawValue {
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        ball.removeFromParent()
                        self.spawnBall()
                    })
                } else {
                    gameOver()
                }
            }
        }
    }
}

