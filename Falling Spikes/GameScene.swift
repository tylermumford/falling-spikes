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
    
    override func didMoveToView(view: SKView) {
        /* Set up the scene */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spike")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    func resetPlayerBallPosition() {
        let x = size.width / 2
        let y = CGFloat(0.0)
        playerBall.position = CGPoint(x: x, y: y)
    }
    
    func drawGridLines() {
        
    }
}
