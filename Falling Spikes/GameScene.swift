//
//  GameScene.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 2/10/16.
//  Copyright (c) 2016 Mindful Code. All rights reserved.
//

import SpriteKit
import GameplayKit

private let ballHeightMax = CGFloat(150)
private let ballHeightMin: CGFloat = {
    let a = SKTexture(imageNamed: "PlayerBall")
    return a.size().height / 2
}()

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerHp = 1 {
        didSet {
            if playerHp == 0 {
                print("playerHP didSet calling gameOver.")
                gameOver()
            }
        }
    }
    let playerBall = SKSpriteNode(imageNamed: "PlayerBall")
    let ballBouncing = SKAction.repeatActionForever(
        SKAction.sequence([
            { let a = SKAction.moveToY(ballHeightMax, duration: 0.6); a.timingMode = .EaseOut; return a }(),
            { let a = SKAction.moveToY(ballHeightMin, duration: 0.6); a.timingMode = .EaseIn; return a }()
        ])
    )
    var spikeDropperX: GKShuffledDistribution!
    var spikeDropperY: GKRandomDistribution!
    var spikes = Set<SKSpriteNode>()
    
    var spikeCount = 6
    
    var lastTouchLocation = CGPoint(x: 0, y: 0) {
        didSet {
            // Move playerBall here
            
            let displacement: CGFloat = {
                let a = lastTouchLocation.x - playerBall.position.x
                let b = lastTouchLocation.y - playerBall.position.y
                return sqrt(a * a + b * b)
            }()
            let stdDisplacement = frame.width * 0.7
            let move = SKAction.moveToX(lastTouchLocation.x, duration: Double(displacement / stdDisplacement))
            move.timingMode = .EaseInEaseOut
            playerBall.runAction(move)
        }
    }
    
    var gameOverFunc: (() -> Void)?
    
    enum Category: UInt32 {
        case Player = 0x00000001
        case Environment = 0x00000010
        case Enemy = 0x00000100
    }
    
    
    override func didMoveToView(view: SKView) {
        
        // Set up scene
        
        let physicsBounds = CGRect(x: position.x, y: position.y - 200, width: frame.width, height: frame.height + 800)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: physicsBounds)
        physicsBody?.categoryBitMask = Category.Environment.rawValue
        physicsBody?.contactTestBitMask = Category.Enemy.rawValue
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.167)
        physicsWorld.contactDelegate = self
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
            s.name = "spike"
            s.physicsBody = SKPhysicsBody(texture: s.texture!, size: s.size)
            s.physicsBody?.categoryBitMask = Category.Enemy.rawValue
            s.physicsBody?.collisionBitMask = Category.Player.rawValue
            s.physicsBody?.contactTestBitMask = Category.Player.rawValue
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
        playerBall.physicsBody?.contactTestBitMask = Category.Enemy.rawValue
        playerBall.userData = ["hp": 1]
        playerBall.runAction(ballBouncing)
        
        // Add nodes
        
        addChild(playerBall)
        spikes.forEach(addChild)
    }
    
    
    // MARK: RNGs
    
    func nextSpikeX() -> CGFloat {
        return CGFloat(spikeDropperX.nextInt())
    }
    
    func nextSpikeY() -> CGFloat {
        return frame.height + CGFloat(spikeDropperY.nextInt())
    }
    
    
    // MARK: Contacts
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactType = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactType {
        case Category.Enemy.rawValue | Category.Environment.rawValue:
            guard contact.contactPoint.y < 0 else { return }
            let spike = contact.bodyB.node?.name == "spike" ? contact.bodyB.node! : contact.bodyA.node!
            let newLoc = CGPoint(x: nextSpikeX(), y: nextSpikeY())
            spike.runAction(SKAction.moveTo(newLoc, duration: 0))
//            spike.physicsBody?.velocity = CGVector(dx: 0, dy: -0.5)
        case Category.Enemy.rawValue | Category.Player.rawValue:
            playerHp -= 1
        default:
            break
        }
    }
    
    
    // MARK: - Gameplay
    
    func gameOver() {
        if let routine = gameOverFunc {
            routine()
        }
    }
    
    // MARK: - Touch events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard playerHp > 0 else { return }
        for touch in touches {
            let location = touch.locationInNode(self)
            lastTouchLocation = location
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard playerHp > 0 else { return }
        for touch in touches {
            let location = touch.locationInNode(self)
            lastTouchLocation = location
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard playerHp > 0 else { return }
        for touch in touches {
            let location = touch.locationInNode(self)
            lastTouchLocation = location
        }
    }
    
}
