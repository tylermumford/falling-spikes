//
//  GameScene.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 2/10/16.
//  Copyright (c) 2016 Mindful Code. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let playerBall = SKSpriteNode(imageNamed: "PlayerBall")
    var spikeDropperX: GKShuffledDistribution!
    var spikeDropperY: GKRandomDistribution!
    var spikes = Set<SKSpriteNode>()
    
    var spikeCount = 8
    var lastTouchLocation = CGPoint(x: 0, y: 0)
    
    enum Category: UInt32 {
        case Player = 0x0000000F
        case Environment = 0x000000F0
        case Enemy = 0x00000F00
    }
    
    
    override func didMoveToView(view: SKView) {
        
        // Set up scene
        
        let physicsBounds = CGRect(x: position.x, y: position.y - 200, width: frame.width, height: frame.height + 800)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: physicsBounds)
        physicsBody?.categoryBitMask = Category.Environment.rawValue
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.3)
        backgroundColor = UIColor.cyanColor()
        spikeDropperX = GKShuffledDistribution(
            lowestValue: Int(frame.minX),
            highestValue: Int(frame.maxX)
        )
        spikeDropperY = GKRandomDistribution(
            lowestValue: 30,
            highestValue: 400
        )
        defer {
            lastTouchLocation = playerBall.position
        }
        
        // Set up nodes
        
        for _ in 0..<spikeCount {
            // Create spikes
            let s = SKSpriteNode(imageNamed: "Spike")
            s.physicsBody = SKPhysicsBody(texture: s.texture!, size: s.size)
            s.physicsBody?.categoryBitMask = Category.Enemy.rawValue
            physicsBody?.collisionBitMask = Category.Player.rawValue
            s.physicsBody?.allowsRotation = false
            s.position.y = nextSpikeY()
            s.position.x = nextSpikeX()
            spikes.insert(s)
        }
        playerBall.position = CGPoint(
            x: size.width / 2,
            y: 0
        )
        playerBall.physicsBody = SKPhysicsBody(texture: playerBall.texture!, size: playerBall.size)
        playerBall.physicsBody?.categoryBitMask = Category.Player.rawValue
        playerBall.physicsBody?.collisionBitMask = Category.Enemy.rawValue & Category.Environment.rawValue
        
        // Add nodes
        
        addChild(playerBall)
        spikes.forEach(addChild)
    }
    
    override func update(currentTime: CFTimeInterval) {
        if playerBall.position != lastTouchLocation {
            playerBall.runAction(SKAction.moveTo(lastTouchLocation, duration: 0.2))
        }
        for spike in spikes {
            // Reset spikes that have fallen below the screen
            if spike.position.y <= -spike.frame.maxY {
                spike.position.y = nextSpikeY()
                spike.position.x = nextSpikeX()
                spike.physicsBody?.velocity = CGVector(dx: 0, dy: -0.5)
            }
        }
    }
    
    
    // MARK: RNGs
    
    func nextSpikeX() -> CGFloat {
        return CGFloat(spikeDropperX.nextInt())
    }
    
    func nextSpikeY() -> CGFloat {
        return frame.height + CGFloat(spikeDropperY.nextInt())
    }
    
    
    // MARK: - Touch events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.count == 2 {
            // TESTING
            view?.presentScene(MenuScene(size: CGSize(width: frame.width, height: frame.height)))
        }
        
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
    
}
