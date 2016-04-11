//
//  MenuScene.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 3/28/16.
//  Copyright © 2016 Mindful Code. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode(imageNamed: "MenuPlayButton")

    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.grayColor()
        
        playButton.xScale = 0.7
        playButton.yScale = 0.7
        playButton.position = CGPoint(
            x: frame.width / 2,
            y: frame.height / 2
        )

        addChild(playButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let point = touch.locationInNode(self)
            if nodeAtPoint(point) == playButton {
                view?.presentScene(GameScene(size: CGSize(
                    width: frame.width,
                    height: frame.height
                )))
            }
        }
    }
}