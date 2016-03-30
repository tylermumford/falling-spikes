//
//  GameScene.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 2/10/16.
//  Copyright (c) 2016 Mindful Code. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playerBall = SKSpriteNode(imageNamed: "PlayerBall")
    var lastTouchLocation = CGPoint(x: 0, y: 0)
    
    
    override func didMoveToView(view: SKView) {
        resetPlayerBallPosition()
        lastTouchLocation.x = playerBall.position.x
        backgroundColor = UIColor.cyanColor()
        
        
        addChild(playerBall)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            lastTouchLocation = location
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            lastTouchLocation = location
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            lastTouchLocation = location
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        playerBall.runAction(SKAction.moveTo(lastTouchLocation, duration: 0.2))
    }
    
    
    func resetPlayerBallPosition() {
        playerBall.anchorPoint = CGPoint(x: 0.5, y: 0)
        playerBall.position = CGPoint(
            x: size.width / 2,
            y: 0
        )
        playerBall.setScale(0.45)
    }
}
