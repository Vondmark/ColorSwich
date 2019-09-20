//
//  MainMenuScene.swift
//  ColorSwich
//
//  Created by Mark on 9/19/19.
//  Copyright © 2019 Mark. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addLabels()
    }
    
    func addLogo() {
        
    }
    
    func addLabels() {
        let playLabel = SKLabelNode(text: "Tap to Play!")
        playLabel.fontName = "Arial"
        playLabel.fontSize = 50.0
        playLabel.fontColor = .yellow
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY+playLabel.frame.size.height)
        addChild(playLabel)
        animate(label: playLabel)
        
        let highScorelabel = SKLabelNode(text: "Highscore: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))")
        highScorelabel.fontName = "Arial"
        highScorelabel.fontSize = 40.0
        highScorelabel.fontColor = UIColor.white
        highScorelabel.position = CGPoint(x: frame.midX, y: frame.midY - playLabel.frame.size.height)
        addChild(highScorelabel)
        
        let recentScoreLabel = SKLabelNode(text: "Score: " + "\(UserDefaults.standard.integer(forKey: "Score"))")
        recentScoreLabel.fontName = "Arial"
        recentScoreLabel.fontSize = 40.0
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - playLabel.frame.size.height-highScorelabel.frame.size.height)
        addChild(recentScoreLabel)
        
    }
    
    func animate(label: SKLabelNode) {
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)

        //another way to animate Play logo!
//        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
//        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        
        let sequence = SKAction.sequence([fadeOut, fadeIn])
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
    
}
